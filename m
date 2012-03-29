Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab2C2W1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:27:31 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57170 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759487Ab2C2W1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:27:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120309124119.GV3273@opensource.wolfsonmicro.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-2-git-send-email-myungjoo.ham@samsung.com> <20120309124119.GV3273@opensource.wolfsonmicro.com>
From: Erik Gilling <konkers@google.com>
Date: Thu, 29 Mar 2012 15:27:01 -0700
Message-ID: <CACSP8ShU5tu=9N53PtYMLyFVFMS9whNRhMvu7nu8rBoPuVCy+Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] Extcon (external connector): import Android's
 switch class and modify.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        NeilBrown <neilb@suse.de>, gregkh@linuxfoundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        myungjoo.ham@gmail.com, John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mike Lockwood <lockwood@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 4:41 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Feb 27, 2012 at 09:15:35PM +0900, MyungJoo Ham wrote:
>
>> +#ifdef CONFIG_ANDROID
>> +             extcon_class = class_create(THIS_MODULE, "switch");
>> +#else /* !CONFIG_ANDROID */
>> +             extcon_class = class_create(THIS_MODULE, "extcon");
>> +#endif /* CONFIG_ANDROID */
>
> This seems somewhat sad - if ANDROID is turned on the standard ABI
> vanishes.  It'd be much nicer to do this with a symlink (or with
> symlinks within the android directory if the driver core doesn't support
> that).  That way userspace code can be written to the new ABI and will
> work on Android systems without ifdefery.

This won't work if userspace code is receiving uevents through netlink
and comparing based on the device name which it does in android.  Why
change the name at all?  Extcon is much more specific than "switch."
A switch can can be used for more than just external connections such
as availability of HMDI audio (which is only available once a HDMI
mode is chosen and the interface is enabled.)

-Erik
