Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0IVJXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:23:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0IVJXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:23:04 -0400
Subject: Re: [PATCH/RFC] timer: fix deadlock on cpu hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <20100922083706.GA2177@osiris.boeblingen.de.ibm.com>
References: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
	 <4C98D0EB.30002@kernel.org> <1285083618.2275.884.camel@laptop>
	 <20100922083706.GA2177@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Sep 2010 11:22:42 +0200
Message-ID: <1285147362.2275.896.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 10:37 +0200, Heiko Carstens wrote:
> > I've wanted to pull the whole migration thread out from SCHED_FIFO for a
> > while. Doing that is probably the easiest thing.
> 
> Something like th 

No that makes it a SCHED_OTHER task, and will indeed result in a wedged
system very quickly.

The idea was to move it to a class of its own above SCHED_FIFO.

I'll try and get something done, but I'm heading out to LinuxCon.JP
soon.
