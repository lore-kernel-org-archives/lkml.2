Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab0KQXhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:37:01 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51405 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751238Ab0KQXg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:36:59 -0500
Date: Thu, 18 Nov 2010 00:38:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.37-rc1+: hibernate regression, claims not enough swap space
Message-ID: <20101117233859.GA23086@elf.ucw.cz>
References: <20101114052138.GB2189@elf.ucw.cz>
 <201011162327.27454.rjw@sisk.pl>
 <20101117211917.GA394@elf.ucw.cz>
 <201011180018.42858.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011180018.42858.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This is not how it works now.  We preallocate memory to create memory pressure,
> > > so if image_size is 0, we need to preallocate until we run out of pages that
> > > can be freed, which means OOM.
> > 
> > That's bad, right? Instead of killing 
> 
> I'm not sure what you mean.

I meant "instead of failing hibernation, you get OOM -- killing random
processes".

> > Anyway, it does not work at all.
> > 
> > root@amd:~# echo 300000000 > /sys/power/image_size
> > root@amd:~# echo disk > /sys/power/state 
> > -su: echo: write error: No space left on device
> > 
> > (And dmesg full of failed allocations).
> > 
> > I can write 400M there, and it fails, too.
> 
> Well, in that case your swap is smaller than the requested image size, isn't it?

No, swap is 

pavel@amd:~/misc$ cat /proc/swaps 
Filename				Type		Size	Used
Priority
/dev/sda1                               partition	779148	0
-1

... 700M.

> There's a check in there that should catch that and it apparently doesn't work.
> 
> Do you have that dmesg by chance?

dmesg is useless -- it is full of backtraces :-(. ACPI allocations
fail.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
