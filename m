Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2ASO16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:27:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2ASO1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:27:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi <andi.shyti@gmail.com>
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Date: Thu, 19 Jan 2012 14:26:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>, "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, lm-sensors@lm-sensors.org,
        linux-input@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com> <201201181403.47806.arnd@arndb.de> <20120118213635.GB3401@gmail.com>
In-Reply-To: <20120118213635.GB3401@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201191426.45923.arnd@arndb.de>
X-Provags-ID: V02:K0:iKci+Ipz8up2/6U92j1+rMULqO4gvlnjWabFq4rge3z
 91DMe1+VKchjPrsCWBc1rohrUed6FMuAZrQfdtck6eX/uCe6cB
 2Bh+Vpfj89c2W+uBcBxMWGRm9csez7DgB+n3eJJ2xNLbo1ouN2
 JP9KStPeFSaduXUFCD74b08Pohwo9RwKxwhAIbFDP3b86Ct8TF
 fBrl6QIiqoLCbU1SStnN9Pul2Eth2dZOo0tujitHe/m5LUjcdA
 728LemGr7j7c7vwbfmZv9V4MCcoHu+PoljLzzwuSntgiGFnZEq
 q/U/iajGoDw/sls9wm3W0+KRbfATXh/+Isx6aXOEGj9cMDlK/l
 BR+1qBlbA7EQkKBwSVXM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 January 2012, Andi wrote:
> What do you mean with "kernel-wide policy for accelerometer drivers"?
> As far as I know, accelerometer drivers are written between the i2c driver and the
> input driver.
> The input driver provides already some accelerometer specific event types, ABS_X, ABS_Y, ABS_Z,
> in your opinion isn't it enough?
> If you mean something like collecting common properties like g range or frequency or whatever in a
> standard interface, then I think that accelerometers are quite different as devices and sometimes
> it could be difficult to arrange a common interface.

The problem is that we have some drivers using the input subsystem, some
drivers using the iio subsystem and some drivers using none of these but
interfacing with user space using some homegrown method, see my list:

> > $ git grep -l accelerometer drivers/ | manual_grep
> > drivers/hwmon/applesmc.c
> >    (one hwmon sysfs attribute for x/y/z)
> > drivers/input/misc/adxl34x.c
> >    (lots of sysfs attributes, input_report_key)
> > drivers/input/misc/cma3000_d0x.c
> >    (input_report_abs)
> > drivers/input/misc/kxtj9.c
> >    (input_report_abs, plus one aux sysfs attribute)
> > drivers/macintosh/ams/ams-core.c
> >    (one sysfs attribute for x/y/z)
> > drivers/misc/lis3lv02d/
> >    (multiple sysfs attributes)
> > drivers/platform/x86/hdaps.c
> >    (multiple sysfs attributes, only x/y)
> > drivers/platform/x86/hp_accel.c
> >    (hooks into drivers/misc/lis3lv02d/)
> > drivers/staging/iio/accel/kxsd9.c
> >    (iio)
> > drivers/staging/iio/accel/sca3000_core.c
> >    (iio plus extra attributes)

If all drivers were using the input subsystem in the way you describe,
that would be a good solution, but right now the majority of the
drivers don't do this.

	Arnd
