Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab1F3IXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:23:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50634 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab1F3IXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110629140619.744da8ea.rdunlap@xenotime.net>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
	<20110629140619.744da8ea.rdunlap@xenotime.net>
Date: Thu, 30 Jun 2011 16:23:04 +0800
Message-ID: <BANLkTi=Gwjoe9LdPZJ-vqwdNjz=Gj1v5-g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc5 (arch/cris)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 5:06 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 29 Jun 2011 10:13:17 +0200 (CEST) Geert Uytterhoeven wrote:
>
>> *** ERRORS ***
>>
>> 698 regressions:
>
>>   + net/mac80211/led.c: error: 'struct led_classdev' has no member named 'trig_list':  => 213, 277
>>   + net/mac80211/led.c: error: dereferencing pointer to incomplete type:  => 73, 91, 100, 82
>>   + net/mac80211/led.c: error: implicit declaration of function 'led_trigger_register':  => 74
>>   + net/mac80211/led.c: error: implicit declaration of function 'led_trigger_unregister':  => 118
>>   + net/mac80211/led.c: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger' :  => 98, 71, 89, 80
>
>
> I think that this is what Andrew would call a cockup, or at least I would.
>
> These errors shouldn't be possible since net/mac80211/Kconfig says:
>
> config MAC80211_LEDS
>        bool "Enable LED triggers"
>        depends on MAC80211
>        depends on LEDS_CLASS
>        select LEDS_TRIGGERS
>
>
>
> Preferably arch/cris/Kconfig would source drivers/Kconfig instead of sourcing
> individual drivers/foobar/Kconfig.
>
> Second option is for arch/cris/Kconfig to source drivers/leds/Kconfig
> unless there is some reason to avoid this (?).
>
> Or we should just prevent this particular driver from being built,
> but that's the least desirable choice here.

For me, net/mac80211/Kconfig should source drivers/leds/Kconfig
since it uses a Kconfig defined there...
