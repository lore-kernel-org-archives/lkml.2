Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab1GYMko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:40:44 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:61390 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1GYMkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:40:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110725131701.112e635e@lxorguk.ukuu.org.uk>
References: <CAPweEDwVhaHr=5i8giGCkDWxK9G8Vvibq59vhbu6RsnZf9uerA@mail.gmail.com>
	<20110725131701.112e635e@lxorguk.ukuu.org.uk>
Date: Mon, 25 Jul 2011 13:40:38 +0100
X-Google-Sender-Auth: IaDUTu2OrsQ9VOwOq3pTlBqj36I
Message-ID: <CAPweEDzQXUTtAwiU4qEB_eQqNgJeazpeTxixyAnbgscvC5yujQ@mail.gmail.com>
Subject: Re: dynamic LCD support for "embedded" systems
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: debian-arm@lists.debian.org, linux-kernel@vger.kernel.org,
        Wookey <wookey@wookware.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 1:17 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>  ok, so.  does anyone on LKML happen to know if there exists in the
>> linux kernel a method for dynamic detection and booting off of
>> absolutely any type of LCD panel?  even if it's a predefined list of
>> say 10 quotes supported quotes static LCD panels?
>
> It depends entirely on the platform, the interconnect, the panel and the
> controller. You may have a way of probing it, but even on a PC in a lot
> of cases the knowledge is actually in the firmware not in the panel
> itself. In some cases the relationship is even more incestuous (eg look
> at some of the MIPI drivers).

 euurgh, inspire me with confidence, why not? :)  yes, virtually every
datasheet for an RGB/TTL LCD panel i've looked at has EDID data which
is typically accessible over an I2C bus.  hilariously (ok maybe not)
i've heard of manufacturers getting this data wrong.  then, you
_still_ need some offsets (the Horizontal and Vertical tuning which
you simply don't have on an embedded LCD panel - there's no buttons
and no adjustment menu on an embedded system!)

 ... but, think about it: that LCD panel goes into a VGA monitor (or
DVI monitor), and that EDID data just gets passed-through via the VGA
IC. so it's all the same stuff... so what's the damn difference
between a system with a VGA monitor and a system with the exact same
LCD panel *from* that VGA monitor, ehn? :)  ok, rhetorical question.

 so, basically, unless you absorb the capabilities of a VGA monitor
*into* the linux kernel and/or the OS running on top of it (think of
that menu system on a VGA monitor), as well as the capabilities
normally offered by a PC "BIOS", true "dynamic" LCD capabilities on an
embedded system - to adapt to literally any LCD panel - are a
pipe-dream.

 so *sigh* that means having a list of static pre-arranged data
structures associated with pre-vetted pre-tested LCD panels (and
identifying them correctly).

> Well really the panel belongs in devicetree. That would I think sort much
> of the mess out.

 *lol* yehhs... drag hundreds of chinese tablet manufacturers kicking
and screaming into the C21st^H^H^H^H^H device tree era - oh god i hope
it's not 2.4 kernel all over again [note for people who may not be
aware: in the embedded world, the 2.4 linux kernel, especially the
2.4.18 and 2.4.20 ones, had a massively extended lifetime because of a
significant performance drop, and increases in compiled size and also
resident memory usage over the 2.6 kernel.  2.4 kernels could be 600k
compiled whilst 2.6 with the exact same options came out at 900k]

 but seriously: i talked with david (from linaro) a few months back,
and he mentioned what the aims of devicetree are, and yes i believe
it's an excellent technical solution, into which something like
dynamic LCD panel startup would fit very well.

 oh.

 wait.

 i have an idea.

 devicetree LCD modules.  these could still be dynamically loaded,
right?  i mean, it's a bit crazy, but you could have associated with a
particular LCD panel a devicetree-compliant dynamic loaded module
which had the correct LCD settings (including the required pre-tested
hsync and vsync data), right?

 thanks alain.

 l.
