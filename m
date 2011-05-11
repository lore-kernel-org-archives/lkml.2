Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab1EKQ77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:59:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42171 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab1EKQ76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ipxcBfhvWemA1wjcQfN1oVKeOwtG5DCgaNyg0B2HqF3VP4U17FjtO3vq6I73FYSLgJ
         AMZMli9w4GMJpe9b1ENgmifhFXKKBIVf8xKcG94u14D+1ENLToPObAk+XnOr4BsFyNez
         I7gwAIUzpdEV7fyHLthulNRFDSdzgRu0GnEPE=
MIME-Version: 1.0
In-Reply-To: <20110511124137.GA2389@patrik-macbook>
References: <20110510212038.GA3279@patrik-macbook>
	<20110510224602.73b24d0a@lxorguk.ukuu.org.uk>
	<BANLkTikz+PrQY2egkPTiacDSH5-Gkqkbww@mail.gmail.com>
	<20110511101022.7f6e583b@bob.linux.org.uk>
	<20110511124137.GA2389@patrik-macbook>
Date: Wed, 11 May 2011 18:59:56 +0200
Message-ID: <BANLkTikwrF3QP63yJAnCG_Y6H8gAkuavCQ@mail.gmail.com>
Subject: Re: [PATCH] gma500: Add option to disable LVDS
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 2:41 PM, Patrik Jakobsson
<patrik.r.jakobsson@gmail.com> wrote:
> On Wed, May 11, 2011 at 10:10:22AM +0100, Alan Cox wrote:
>> > pipes and LVDS only finds a bogus mode of 0x0 pixels. Not sure why
>> > LVDS takes over instead of SDVO since it has valid modes, but my
>> > screen just goes into powersave when no proper PLL can be set for the
>> > bogus mode.
>>
>> Well that is hopeful. If we get a bogus 0x0 pixel mode it means it did
>> detect something invalid but for some reason we didn't punt on it.
>>
>> Alan

> Here's the dmesg with drm_debug=7, LVDS is also enabled here.

> [  165.383050] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
> [  165.383060] [drm:drm_mode_debug_printmodeline], Modeline 0:"0x0" 0 0 0 0 0 0 0 0 0 0 0x8 0x0

The mode comes from the video bios table. When skipping the bios probe
I get a working framebuffer but the backlight code crashes so this
needs to be handled.

I'll send a patch that throws away that mode and skips backlight if
there is no lvds ouput.

-Patrik
