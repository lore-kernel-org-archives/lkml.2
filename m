Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1IMOWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:22:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49963 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab1IMOWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:22:34 -0400
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Tue, 13 Sep 2011 16:22:04 +0200
In-Reply-To: <4E6F41EB.1040106@redhat.com>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
	  <1315836358.26517.43.camel@twins> <4E6E1693.7080606@redhat.com>
	 <1315837930.26517.49.camel@twins> <4E6F41EB.1040106@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315923724.5977.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 14:43 +0300, Avi Kivity wrote:

> Another issue is that hypervisors use PAUSE to detect a spinning guest 
> and issue a directed yield to another vcpu.  But for cmpxchg loops, the 
> "spinner" would just commit on the next loop, no?  So I think there's no 
> objection from that front.

Right, we shouldn't ever spend a significant amount spinning on a
cmpxchg. If we do we need to fix that instead.
