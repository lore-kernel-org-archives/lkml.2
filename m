Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab0IAGej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:34:39 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51069 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0IAGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:34:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=msRMnNR58tK2QhtCc11kBOmh6GlwWB8OvsJvPjrgHuFhjbQAV837LLN5AdOId5qScy
         IPH3QPuKlXpl6wviUYYLIZ72CuiIvy1TqoJEakvMgZk8OWm7r4pH6OGPNK85FsSdd042
         sW5TxF4bhatKfqKoVJjFsUYiZEvebltCURGFE=
Date: Tue, 31 Aug 2010 23:34:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Leeder <nleeder@codeaurora.org>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>, Hsin.Wu@quantatw.com,
        mcuos.com@gmail.com
Subject: Re: [PATCH 0/1] input: keyboard: add qci keyboard driver
Message-ID: <20100901063430.GG23585@core.coreip.homeip.net>
References: <4C7838DD.1020004@codeaurora.org>
 <201008271533.01542.dmitry.torokhov@gmail.com>
 <4C7BF6D2.5080501@codeaurora.org>
 <20100830215556.GC28865@core.coreip.homeip.net>
 <4C7D6C17.1070604@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7D6C17.1070604@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 04:54:47PM -0400, Neil Leeder wrote:
> On 8/30/2010 5:55 PM, Dmitry Torokhov wrote:
> >And still you are using only one GPIO in your driver? While WPCE775x
> >does seem to have matrix keypad support I think that you are using one
> >of the 3 PS/2 ports, like your touchpad does.
> 
> Hi Dmitry,
> 
> I can assure you that the keyboard is on the 8*18 GPIO matrix on the
> Nuvoton EC (only 8*16 being used in the current design). There
> certainly are 3 PS/2 ports on the EC, but in the board designs I
> have only one of those is used as a PS/2 port, and that is for the
> touchpad. The other two ports are muxed with GPIOs and the pins are
> being used as GPIOs for other functions, not PS/2 ports.
> 
> The firmware on the EC converts keypresses on the GPIO matrix to
> scancodes and sends them over I2C. The single GPIO used by the
> keyboard driver is an interrupt.
> 
> >The device is initialized with 0xf4; the device is supposed to respond
> >with 0xfa; I wonder what scancodes the device reports... It smells
> >strongly of PS/2.
> >
> >Also, it is not controller that supports PS/2 commands but rather the
> >device itself so I am still hopeful that we could make use of the
> >standard drivers.
> 
> We can speculate on the reasons that the firmware on the EC uses
> 0xF4 & 0xFA for init and ack - my guess would be for a minimal
> amount of commonality with the PS/2 protocol - but it doesn't
> emulate the rest of the PS/2 protocol for the GPIO matrix device. I
> tried with atkbd. It issues reset, getid, setleds - all of which
> fail with no response from the EC. It only responds to F4.

OK, I give up on pursuit of serio solution. Again ;)

> 
> The scancodes reported are whatever the firmware provides. A
> previous version of firmware had some non-standard values and the
> driver had to use a look-up table to convert them to something
> useful. With the change to the current keyboard layout Quanta
> changed the scancodes reported to match the KEY_* values in input.h,
> which is why there is no table in the current driver.

I believe we still should support changing keymap via EVIOCSKEYCODE so
we need to have the keymap even though the initial seed is 1:1 with
scancodes.

-- 
Dmitry
