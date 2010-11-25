Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0KYOm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:42:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab0KYOm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:42:26 -0500
Date: Thu, 25 Nov 2010 15:41:57 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dan Carpenter <error27@gmail.com>, chris@chris-wilson.co.uk,
        mjg@redhat.com, rpurdie@rpsys.net, kernelorg@bof.de,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: back light conflict i915 vs dell-laptop
Message-ID: <20101125144157.GN6118@random.random>
References: <20101125093301.GT1522@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125093301.GT1522@bicker>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 12:33:01PM +0300, Dan Carpenter wrote:
> Patrick Schaaf has reported that the i915 driver is setting his
> backlight very dim when he starts GDM.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=23472
> 
> It should be the dell-laptop platform driver controlling his backlight.
> 
> Gnome tries to restore the backlight settings through the dell_laptop
> interface in sysfs but it fails.  (Because the platform hardware refuses
> to set the settings to what it thinks they already are).

I think I run into the same problem, xset dpms force standby is enough
to trigger it, after that the backlight will never come up again. I
need to suspend to ram to be able to see my screen again. The screen
is on, just the backlight is off. Not dimmed to low level: completely
off.

Ironically xset dpms force off will come up right... but all screen
powermanagement will start with standby, so I'm stuck for the last few
weeks in presentation mode to be able to work on 37-rc1... It was fine
in .36 and it broke in 37-rc1.

I reported it to chris@chris-wilson.co.uk on 8 Nov but got no reply.

If you need me to test something let me know. It's super annoying when
I unplug the laptop and it exits presentation mode...

CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y

Thanks,
Andrea
