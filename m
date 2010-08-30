Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0H3Nqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:46:38 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:48529 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754774Ab0H3Nqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:46:36 -0400
X-Authenticated: #65048216
X-Provags-ID: V01U2FsdGVkX1+gsutQ4Zagjt2lTTVsDrP6XPKZbUdk+Cyu8FFZ0g
	WOyAq7Gxmm5oz8
Subject: Re: i915: wrong framebuffer size in 2.6.36-rc3
From: Ivan Bulatovic <combuster@gmx.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Sven Joachim <svenjoac@gmx.de>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <AANLkTi=SHwkFFNEUsbJR-eJnyWcDFXcWD-CRPN8uiSHK@mail.gmail.com>
References: <87wrr8cui7.fsf@turtle.gmx.de>
	 <AANLkTi=SHwkFFNEUsbJR-eJnyWcDFXcWD-CRPN8uiSHK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 15:46:29 +0200
Message-ID: <1283175989.11293.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 12:57 +0300, Pekka Enberg wrote: 
> On Mon, Aug 30, 2010 at 12:36 PM, Sven Joachim <svenjoac@gmx.de> wrote:
> > On my laptop which has a 1280x800 display, only the upper left 848x480
> > pixels are used on the console in 2.6.36-rc3.  The resolution is
> > correct, but /sys/class/graphics/fb0/modes looks like this:
> >
> > U:848x480p-0
> >
> > This is a regression from 2.6.35.  The graphics card according to lspci:
> >
> > 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
> > 943/940GML Express Integrated Graphics Controller (rev 03)
> 
> Yeah, you're not alone on this:
> 
> http://lkml.org/lkml/2010/8/23/452
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


If that's the only problem you have then revert this commit:


commit
9559fcdbff4f93d29af04478bbc48294519424f5


> drm/i915: fix vblank wait test condition
> 
> When converting this to the new wait_for macro I inverted the wait
> condition, which causes all sorts of problems.  So correct it to fix
> several failures caused by the bad wait (flickering, bad output
> detection, tearing, etc.).
> 
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9559fcdbff4f93d29af04478bbc48294519424f5


