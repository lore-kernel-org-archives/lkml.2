Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1B0RNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 12:13:52 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46046 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1B0RNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 12:13:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N3C7JsOU0HQhmfqCRMwxs8mJq+tSmkdpXpHsIQpwFBvWsNMxxDBpCQMSYfOJv5D6+M
         UV8XHVwxqFvZqs9Zh4Ju+VHqs/CxJHJOfzQV2BoEdi9bZ8GF4Xp5TrmV//aFJ0eYnfiq
         xr6aguOVf+POmzCtC1/y35Hv1CY1adzK85raY=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=xoiCg9AQJDMjVC=pT-t0XKc+FQ9GZujD3pjHE@mail.gmail.com>
References: <4D671556.80607@suse.com>
	<20110225060706.GA12723@merkur.ravnborg.org>
	<AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
	<20110226221838.GA24028@merkur.ravnborg.org>
	<AANLkTi=xoiCg9AQJDMjVC=pT-t0XKc+FQ9GZujD3pjHE@mail.gmail.com>
Date: Sun, 27 Feb 2011 12:13:47 -0500
Message-ID: <AANLkTimnvAZW_EBC_Y72pEWz2fjE+djkfi60u78XPpeT@mail.gmail.com>
Subject: Re: [PATCH] Add ``cloneconfig'' target
From: Arnaud Lacombe <lacombar@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 27, 2011 at 4:03 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Sat, Feb 26, 2011 at 23:18, Sam Ravnborg <sam@ravnborg.org> wrote:
>> On Sat, Feb 26, 2011 at 02:47:01PM -0500, Arnaud Lacombe wrote:
>>> On Fri, Feb 25, 2011 at 1:07 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>> > We already have something remotely similar in kconfig.
>>> > We use the following list:
>>> > config DEFCONFIG_LIST
>>> >        string
>>> >        depends on !UML
>>> >        option defconfig_list
>>> >        default "/lib/modules/$UNAME_RELEASE/.config"
>>> >        default "/etc/kernel-config"
>>> >        default "/boot/config-$UNAME_RELEASE"
>>> >        default "$ARCH_DEFCONFIG"
>>> >        default "arch/$ARCH/defconfig"
>>> >
>>> I may argue that anything within the Linux tree which point
>>> _by_default_ to something outside the tree itself is broken.
>> The above allows the average user to just type "make menuconfig"
>> and then the configuration of the current kernel is presented to
>> the user. This is convinient in many cases.
>> We know the /proc/config.gz is an incresingly popular way to gain
>> access to the configuration of the running kernel. So extending
>> the already know and working way to obtaing the configuration
>> of the running kernel to suppport /proc/config.gz is logical.
>
> Does this detect cross-compiling?
>
No.

% gmake ARCH=mips menuconfig
#
# using defaults found in /boot/config-2.6.35.11-83.fc14.x86_64
#
[...]

% gmake CROSS_COMPILE=bla ARCH=mips menuconfig
#
# using defaults found in /boot/config-2.6.35.11-83.fc14.x86_64
#
[...]

Which is plainly just wrong.

 - Arnaud

> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>
