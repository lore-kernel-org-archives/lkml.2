Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab1GYNMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:12:39 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:54875 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1GYNMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAPweEDzQXUTtAwiU4qEB_eQqNgJeazpeTxixyAnbgscvC5yujQ@mail.gmail.com>
References: <CAPweEDwVhaHr=5i8giGCkDWxK9G8Vvibq59vhbu6RsnZf9uerA@mail.gmail.com>
	<20110725131701.112e635e@lxorguk.ukuu.org.uk>
	<CAPweEDzQXUTtAwiU4qEB_eQqNgJeazpeTxixyAnbgscvC5yujQ@mail.gmail.com>
Date: Mon, 25 Jul 2011 14:12:35 +0100
X-Google-Sender-Auth: QhNFW-_V6OMzNMITI2zwh-RAmnQ
Message-ID: <CAPweEDzG82Cja+MAL-F93rdGYTU_rDOk-wTSDzsPW3w=p5_H1A@mail.gmail.com>
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

On Mon, Jul 25, 2011 at 1:40 PM, Luke Kenneth Casson Leighton
<lkcl@lkcl.net> wrote:

>  i have an idea.
>
>  devicetree LCD modules.  these could still be dynamically loaded,
> right?  i mean, it's a bit crazy, but you could have associated with a
> particular LCD panel a devicetree-compliant dynamic loaded module
> which had the correct LCD settings (including the required pre-tested
> hsync and vsync data), right?

 sorry to be following-up to my own posts: thought-continuation error,
Does Not Compute :)

 ok, the context is as follows:

 * plugnpray CPU module, de-facto standard interface(s), USB2, I2C,
Ethernet, LCD, GPIO, blah blah
 * Motherboards (conforming to de-facto standard interface), but apart
from that, can be any design.

 examples:

 * CPU module Cortex A8, 1gb RAM
 * CPU module Cortex A9, 1gb RAM
 * CPU module MIPS Ingenic jz4770
 * Motherboard 7in tablet, 800x480 LCD
 * Motherboard 11in laptop, 1280x768 LCD
 * Desktop PC (VGA or DVI converter on LCD data)

 i.e. radically different CPU modules, and radically different motherboards.

 that's the context.

 question: how the bloody hell do you make sure that any of the CPU
modules can plug into any of the motherboards... *including* future
CPU modules and including *unknown* motherboards yet to be designed..
and actually boot up the LCD. correctly.

  i thought: yeah, yeah, make a devicetree-compliant dynamic module,
put it on some storage on the motherboard: CPU module boots up, mounts
the motherboard storage, loads the module, everything hunky-dory.

 except... then you're into "linux kernel upgrade hell".  and you'd
have to have, pre-loaded on the motherboard storage, a
devicetree-compliant LCD dynamic module for 2.6.N for MIPS, another
one for the 2.6.N Cortex A8 CPU(s) ... no, it's hell on earth.

 but then it occurred to me... well... why bother having that data in
a kernel module (esp. if it has to go on a filesystem anyway), why not
just have that LCD data in a text file?   somewhere in
/lib/firmware/edid_data or something like that?

 so, you go through the heuristics-process (arnaud's just kindly
described some of what is needed here:
http://lists.debian.org/debian-arm/2011/07/msg00054.html ) and then
you go look up the actual required LCD settings off of
/lib/firmware/{somewhere}, drop them into the one generic (and
statically-loaded, yaay!) devicetree-compliant module, everything's
hunky-dory.

 does that sound like a reasonable plan, or have i completely lost
everyone at this point? :)

 l.
