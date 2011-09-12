Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab1ILPYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:24:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:52070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab1ILPYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:24:41 -0400
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Sep 2011 17:24:20 +0200
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
	 <1315836358.26517.43.camel@twins>
	 <20110912142305.GN7761@one.firstfloor.org> <20110912144706.GA21716@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315841060.26517.67.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 17:09 +0200, Peter Zijlstra wrote:

> Furthermore, I would argue we should avoid growing them, significantly
> contended atomic ops are bad, use a different scheme.

To clarify, plain cmpxchg loops are unfair and unbounded in completion
time, and we should therefore avoid any sort of medium/high contention.
If you get into that situation you're doing it wrong.


