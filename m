Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2DSCgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 22:36:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55610 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2DSCgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 22:36:46 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20120418214703.GA31606@kroah.com>
References: <1332492784-10526-1-git-send-email-myungjoo.ham@samsung.com>
	<1332492784-10526-2-git-send-email-myungjoo.ham@samsung.com>
	<20120418214703.GA31606@kroah.com>
Date: Thu, 19 Apr 2012 11:36:45 +0900
X-Google-Sender-Auth: 3gHuKPb0DFyH7CZfyNYni0-xhcQ
Message-ID: <CAJ0PZbQ2Q9p9NpJfJtAGDzNv-aq2cKswgLq5Q9op3UDJjQAG6w@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] Extcon (external connector): import Android's
 switch class and modify.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, cw00.choi@samsung.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 6:47 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 23, 2012 at 05:52:58PM +0900, MyungJoo Ham wrote:
>> External connector class (extcon) is based on and an extension of
>> Android kernel's switch class located at linux/drivers/switch/.
>
> <snip>
>
> This patch breaks the build:
> drivers/extcon/extcon_class.c:79:6: error: redefinition of ‘extcon_set_state’
> include/linux/extcon.h:80:20: note: previous definition of ‘extcon_set_state’ was here
> drivers/extcon/extcon_class.c:170:5: error: redefinition of ‘extcon_dev_register’
> include/linux/extcon.h:67:19: note: previous definition of ‘extcon_dev_register’ was here
> drivers/extcon/extcon_class.c:214:6: error: redefinition of ‘extcon_dev_unregister’
> include/linux/extcon.h:73:20: note: previous definition of ‘extcon_dev_unregister’ was here
>
> So it obviously can't be applied to the tree :(
>
> Did you test it?
>
> Care to redo this series and send it again?
>
> greg k-h

Hello,

That error is very wierd. It implies that CONFIG_EXTCON is "not
defined" in extcon.h and CONFIG_EXTCON is "defined" in Makefile so
that extcon_class.c is compiled.

However, the patchset v8 (some bugfixes over patchset v7) that is
tested on the base of Linux 3.4-rc3 w/ and w/o CONFIG_EXTCON and has
been used with MAX77693-MUIC devices is on the way.

Thanks.


Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
