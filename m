Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0DKRSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 13:18:25 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54795 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752345Ab0DKRSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 13:18:24 -0400
Date: Sun, 11 Apr 2010 19:18:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bernie Thompson <bernie@plugable.com>
Cc: roberto@unbit.it, gregkh@suse.de, Cyril Hrubis <metan@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: staging: udlfb -- staging version does not work, external does
Message-ID: <20100411171856.GA24163@elf.ucw.cz>
References: <20100411072625.GA9926@elf.ucw.cz>
 <n2g480988181004110742w2ce92bfdr4f0f01216f879fe8@mail.gmail.com>
 <20100411170117.GA22007@elf.ucw.cz>
 <p2s480988181004111005kdeb479ddzd3719799f140f4a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p2s480988181004111005kdeb479ddzd3719799f140f4a9@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-04-11 10:05:12, Bernie Thompson wrote:
> Roberto - why would any mmap'd writes get immediately displayed on the
> older code?  I wouldn't expect that.
> 
> I'm assuming this is mmio path, and that there's no triggers for
> repaint in the older code?
> 
> Pavel - the issue for mmio access is when to trigger repaint.

I'm not doing any memory mapped access (that's what mmio means,
right?). I even checked with strace -- cat uses plain old
read()/write() syscalls.

cat /bin/bash > /dev/fb1

(can you try it on your system? do we agree that it should fill cca
half of screen with noise?)

> Repainting the entire screen is extremely expensive, and mmio doesn't
> have any built-in trigger point.  This issue is what the whole defio
> circus (page-fault based trigger) has been about for the last few
> months.  Some history at:  http://plugable.com/category/project/udlfb/

Ok, I'll take a look.... ...

   Todo

(this should really go to udlfb/TODO).

  ...
     * Disable defio by default, unfortunately, because of several
bugs without obvious solutions
          * rendering problems with pages (lines) that no longer get
updated - writes to those are
            no longer triggering deferred processing
          * When running 2 USB adapters, dirty pages for one instance
seem to affect the other, and
            vice versa (udlfb has no common state, so appears to be in
defio or mmu handling)
          * cases where we hit a kernel oops in the deferred io
handler when it tries to touch the
            pages it's been asked to handle.
  ...

Aha, so this one is even known. How do I re-enable defio support, so
that it can be debugged?

And... can we do something stupid like full repaint once a second to
get basically working driver?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
