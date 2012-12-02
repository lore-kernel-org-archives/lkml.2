Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2LBOmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 09:42:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64712 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2LBOml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 09:42:41 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1738269086.121732.1354456173261.JavaMail.root@elliptictech.com>
References: <CAKMK7uGrLvmDa+pqStAK_E_rEmgAgR+BO6+-m2dgUk6Ut6DuCQ@mail.gmail.com>
	<1738269086.121732.1354456173261.JavaMail.root@elliptictech.com>
Date: Sun, 2 Dec 2012 15:42:39 +0100
Message-ID: <CAKMK7uG3CvfvmMdusSUQf9+rOv_W1AWmoEqH4EAGgCiTyRfNeg@mail.gmail.com>
Subject: Re: Brightness control fails between 3.6.8 and 3.7.0-rc7 (Intel
 915/Dell Vostro 3560)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 2, 2012 at 2:49 PM, Tom St Denis <tstdenis@elliptictech.com> wrote:
> Ok so on v3.7-rc1 [and I suspect up] I can manually control the brightness by echoing to
>
> /sys/class/backlight/intel_backlight/brightness
>
> But I still can't use the buttons to control it (it only goes one tick down from max and stops there).  I'm using GNOME3 from a x86_64 unstable debian install [up to date with latest].
>
> I just noticed that under v3.7 I have a new directory /sys/class/backlight/acpi_video1 which is what GNOME is actually controlling.  I can't disable ACPI video control so is there a workaround?

Hah, acpi registered a broken backlight driver, which overwrites the
intel backlight - for once it's not i915.ko's fault ;-) For a
workaround either disable the acpi backlight with
acpi_backlight=vendor (iirc) kernel option or teach the X driver that
you want a different backlight driver in the xorg.conf (Option
"Backlight" "intel_backlight" should do the trick).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
