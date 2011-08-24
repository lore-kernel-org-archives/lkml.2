Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab1HXFw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 01:52:28 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:51460 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab1HXFwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 01:52:25 -0400
Date: Wed, 24 Aug 2011 07:52:16 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nohz: remove "Switched to NOHz mode" debugging messages
Message-ID: <20110824055216.GA2511@osiris.boeblingen.de.ibm.com>
References: <20110823112046.GB2540@osiris.boeblingen.de.ibm.com>
 <1314126777.1659.2.camel@Joe-Laptop>
 <4E53FC67.7090108@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E53FC67.7090108@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 12:15:51PM -0700, Stephen Boyd wrote:
> On 08/23/2011 12:12 PM, Joe Perches wrote:
> > On Tue, 2011-08-23 at 13:20 +0200, Heiko Carstens wrote:
> >> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> >>
> >> When performing cpu hotplug tests the kernel printk log buffer gets flooded
> >> with pointless "Switched to NOHz mode..." messages. Especially when afterwards
> >> analyzing a dump this might have removed more interesting stuff out of the
> >> buffer.
> >> Assuming that switching to NOHz mode simply works just remove the printk.
> >> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > []
> >> -
> >> -	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
> > Though I don't know if these are actually particularly
> > useful messages, perhaps pr_info_ratelimited() might
> > be appropriate instead.
> 
> Or perhaps a printk_once() would be good. Presumably the second switch
> to NOHz mode wouldn't be as dangerous as the first.

Let's just remove them.
