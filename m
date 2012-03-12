Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2CLIGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 04:06:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57994 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab2CLIGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 04:06:24 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20120309124119.GV3273@opensource.wolfsonmicro.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
	<1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
	<1330344939-18394-2-git-send-email-myungjoo.ham@samsung.com>
	<20120309124119.GV3273@opensource.wolfsonmicro.com>
Date: Mon, 12 Mar 2012 17:06:23 +0900
X-Google-Sender-Auth: a3u36J02Y0Rsk3crle642kINt3o
Message-ID: <CAJ0PZbTnKf2VA-OCyVjEC7kf7mnqt04UDjDw-zqi8f7J6yJUiA@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] Extcon (external connector): import Android's
 switch class and modify.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, gregkh@linuxfoundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 9:41 PM, Mark Brown
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

Yes, this was the itching part.

I'll first look into creating symlinks (either /sys/class/switch -->
/sys/class/extcon or /sys/class/switch/* --> /sys/class/extcon/*).
However, I think this symbolic links are better created selectively w/
CONFIG_ANDROID.

Thanks.


Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
