Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0C2Qor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:44:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:60102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab0C2Qop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:44:45 -0400
Subject: Re: KVM bug, git bisected
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1269880140.12097.356.camel@laptop>
References: <4BADFD74.8060904@gmail.com>  <4BB0D11A.607@redhat.com>
	 <1269880140.12097.356.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 18:44:42 +0200
Message-ID: <1269881082.12097.359.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 18:29 +0200, Peter Zijlstra wrote:

> > Peter, would it be safe to increase PREEMPT_BITS to eg. 10?

One reason this all sucks massive is that nesting that many spinlocks
creates a terribly large !preempt section.

There is nothing that stops someone from creating 64k vmas (or more when
someone raises that sysctl) and try this, that's just utter suckage.

