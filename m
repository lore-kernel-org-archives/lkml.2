Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495Ab2C3I4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 04:56:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40662 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759611Ab2C3I4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 04:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <CACSP8ShU5tu=9N53PtYMLyFVFMS9whNRhMvu7nu8rBoPuVCy+Q@mail.gmail.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
	<1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
	<1330344939-18394-2-git-send-email-myungjoo.ham@samsung.com>
	<20120309124119.GV3273@opensource.wolfsonmicro.com>
	<CACSP8ShU5tu=9N53PtYMLyFVFMS9whNRhMvu7nu8rBoPuVCy+Q@mail.gmail.com>
Date: Fri, 30 Mar 2012 17:56:01 +0900
Message-ID: <CAJ0PZbT728rhQ5esf0arRw-TtgBGMCgAvZhW9-AejmbT9WOahw@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] Extcon (external connector): import Android's
 switch class and modify.
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Erik Gilling <konkers@google.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, NeilBrown <neilb@suse.de>,
        gregkh@linuxfoundation.org, Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mike Lockwood <lockwood@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 7:27 AM, Erik Gilling <konkers@google.com> wrote:
> On Fri, Mar 9, 2012 at 4:41 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>> On Mon, Feb 27, 2012 at 09:15:35PM +0900, MyungJoo Ham wrote:
>>
>>> +#ifdef CONFIG_ANDROID
>>> +             extcon_class = class_create(THIS_MODULE, "switch");
>>> +#else /* !CONFIG_ANDROID */
>>> +             extcon_class = class_create(THIS_MODULE, "extcon");
>>> +#endif /* CONFIG_ANDROID */
>>
>> This seems somewhat sad - if ANDROID is turned on the standard ABI
>> vanishes.  It'd be much nicer to do this with a symlink (or with
>> symlinks within the android directory if the driver core doesn't support
>> that).  That way userspace code can be written to the new ABI and will
>> work on Android systems without ifdefery.
>
> This won't work if userspace code is receiving uevents through netlink
> and comparing based on the device name which it does in android.  Why
> change the name at all?  Extcon is much more specific than "switch."
> A switch can can be used for more than just external connections such
> as availability of HMDI audio (which is only available once a HDMI
> mode is chosen and the interface is enabled.)
>
> -Erik

With class_compat as in patchset v7, (this thread is w/ v6) does the
issue (missing link from device name directory) still exist? (I don't
think so)

In the earlier iteration of dicussion, the name "switch" was dropped
as "switch" may mislead the concept.
https://lkml.org/lkml/2011/11/29/299

For HDMI and HDMI-audio, although HDMI-audio is not physically
seperated from HDMI-cable and it is available after HDMI-cable is
"attached", HDMI-audio is still an external connection to the kernel
and its device drivers, isn' it?

Cheers!
MyungJoo.
-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
