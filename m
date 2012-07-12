Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151Ab2GLRCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:02:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934096Ab2GLRCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:02:50 -0400
Date: Thu, 12 Jul 2012 13:02:42 -0400
From: Dave Jones <davej@redhat.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
Message-ID: <20120712170242.GA11890@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Kay Sievers <kay@vrfy.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartmann <greg@kroah.com>
References: <20120709180328.GA4105@redhat.com>
 <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
 <1341859731.801.0.camel@mop>
 <20120712005405.GA1613@redhat.com>
 <CAPXgP13J98an3GW1-aBOEk=5Vyr+is1DaPhz-UFWHBOJ2nHkKA@mail.gmail.com>
 <20120712140552.GA13745@redhat.com>
 <CAPXgP134KL_hxnsH4OcwGX-mv6hfaRiH9r7Tn4a5XXYzh6EZqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP134KL_hxnsH4OcwGX-mv6hfaRiH9r7Tn4a5XXYzh6EZqA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 06:47:57PM +0200, Kay Sievers wrote:
 
 > >  > > Also, I have no idea how the hell the 'Modules linked in:' line (9th line) ended up being printed /after/ the
 > >  > > module listing began (2nd line).
 > 
 > They do not belong together. The second line is just another call to
 > the same print_modules() done from:
 >     arch/x86/kernel/dumpstack_64.c :: show_regs()
 > 
 > While we already called print_modules() a few cycles earlier from:
 >    kernel/watchdog :: watchdog_timer_fn()

ah, derp. Good spotting.
 
 > Hmm, it does not trigger your pattern. I tried adding an rmmod in that
 > loop, but that crashes after a few seconds. Some modules are just not
 > meant to be removed. :)

yeah, that's bothersome. TTBOMK, we've never survived a 'load all modules/unload all modules' ever.
 
 > I forced the watchdog to trigger by setting the timeout to 1s, but all
 > looks still fine:
 > 
 > Could it possibly be that we get some sort of corruption somewhere
 > else while running trinity and load modules?

I suppose anything is possible, but it's surprisingly consistent.

	Dave
