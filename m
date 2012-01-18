Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab2ARRLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:11:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab2ARRLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:11:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>, linux-input@vger.kernel.org
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Date: Wed, 18 Jan 2012 17:11:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>, "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com> <201201181403.47806.arnd@arndb.de> <b659db7b-2ef1-49b8-9752-a0601226cc6e@email.android.com>
In-Reply-To: <b659db7b-2ef1-49b8-9752-a0601226cc6e@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201181711.15751.arnd@arndb.de>
X-Provags-ID: V02:K0:nVP84nNDE5WQkN10iQomx4wyHPjP/x7dB1SmcS2po01
 TWKZL34ieZSHAkGbk3+PPLt5BowQLA8eDhih6k6B6IpebzsSt0
 Atobi0K99fxaYWymPq7VDGifxygdsaPxk/fpUWjixNZqlAD76w
 U+AtGW4a2fOsJ8G4+V6LDlc/FiAeRhqOOXTh/ZSBTqev4/pHzC
 L66+amuEG24bkpI1AfptH5lefeNj3LZWFD/1uCPghTMDU3k8a/
 vrGslWWKFQVvNJmZz0Jf7B5H9r26AOMd7VtkQ4+TPtrxj9v3nV
 NxzqnKswcxi3/iPP1a0H+OawLgsV4idMLl4u1b3mdFF3ebS2yx
 6hvIwWc5Ifi7QUrgU0/k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 January 2012, Jonathan Cameron wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
>
> >Any opinions where they should live? input, iio or a new subsystem?
> >
> Personal thought is that straight 3d devices very directed at input
> should go there. Iio has a few wrinkles left for the in kernel
> interfaces needed for a bridge to input. For starters the pull 
> and push data interfaces have not merged yet (in staging) and we
> have not started on in kernel acess to non data events yet(thresholds).
> Still happy to take them when we can support usecases fully. 

Ok, thanks for the information, sounds all reasonable. I think we
can definitely say no to new accelerometer drivers in drivers/misc
then and refer them to iio and input.

In case of lis33ldlh, I would like to see it move out at some point
once the necessary parts of iio have graduated out of staging.
Hopefully it won't be a large amount of work to convert it to
a different internal API.

AnilKumar, what are the existing users of the driver? Is it still
possible to convert them to use iio without causing problems for
people that rely on this driver, or do we have to keep supporting the
current interface?

	Arnd
