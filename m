Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0KRMn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:43:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60810 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab0KRMn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:43:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.37-rc1+: hibernate regression, claims not enough swap space
Date: Thu, 18 Nov 2010 13:43:00 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <20101114052138.GB2189@elf.ucw.cz> <201011180018.42858.rjw@sisk.pl> <20101117233859.GA23086@elf.ucw.cz>
In-Reply-To: <20101117233859.GA23086@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011181343.00978.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 18, 2010, Pavel Machek wrote:
> Hi!
> 
> > > > This is not how it works now.  We preallocate memory to create memory pressure,
> > > > so if image_size is 0, we need to preallocate until we run out of pages that
> > > > can be freed, which means OOM.
> > > 
> > > That's bad, right? Instead of killing 
> > 
> > I'm not sure what you mean.
> 
> I meant "instead of failing hibernation, you get OOM -- killing random
> processes".

That's not the case.  The OOM _killer_ is disabled during hibernation, but
there's some more OOM code that's trying very hard to free whatever pages
it can get without killing any processes.

> > > Anyway, it does not work at all.
> > > 
> > > root@amd:~# echo 300000000 > /sys/power/image_size
> > > root@amd:~# echo disk > /sys/power/state 
> > > -su: echo: write error: No space left on device
> > > 
> > > (And dmesg full of failed allocations).
> > > 
> > > I can write 400M there, and it fails, too.
> > 
> > Well, in that case your swap is smaller than the requested image size, isn't it?
> 
> No, swap is 
> 
> pavel@amd:~/misc$ cat /proc/swaps 
> Filename				Type		Size	Used
> Priority
> /dev/sda1                               partition	779148	0
> -1
> 
> ... 700M.
> 
> > There's a check in there that should catch that and it apparently doesn't work.
> > 
> > Do you have that dmesg by chance?
> 
> dmesg is useless -- it is full of backtraces :-(. ACPI allocations
> fail.

What about:

# echo core > /sys/power/pm_test
# echo disk > /sys/power/state

Then the messages should be there in the logs.

Thanks,
Rafael
