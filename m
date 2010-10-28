Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab0J1MXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:23:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50500 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0J1MW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:22:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Date: Thu, 28 Oct 2010 14:22:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz.Rymanowski@tieto.com
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com> <20101022135130.617f0ce8@lxorguk.ukuu.org.uk> <AANLkTik-S50ZX6mFG+vWhBv0x_WmipP=t+4VqmAgssRC@mail.gmail.com>
In-Reply-To: <AANLkTik-S50ZX6mFG+vWhBv0x_WmipP=t+4VqmAgssRC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010281422.46687.arnd@arndb.de>
X-Provags-ID: V02:K0:Lr3K/n8St3IJlmcSG+ak0zuFYAy1+wZNQZ5jAheUXnO
 JF+hAp5LAH20wLLg4/A7ht+u36D7cJ/brLnVGpuYR/OLp39Rj1
 pJGPlgBpm18kqnnCl2YjuyXD2SqvmhG6V1Dhoh42uXiY988ux6
 YbdN9CodHkf1xwPtKkF89NYrxL+nSlrWRPsMX/Hg4cjfNqnTQ3
 k/rrT3DILSILwPIPpf8kg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 October 2010, Par-Gunnar Hjalmdahl wrote:

> >
> > So - NAK this for the moment, it needs to be split cleanly into ldisc
> > (thing which speaks the protocol and eg sees "speed change required" and
> > acts on it) and device (thing which knows about the hardware).
> 
> OK. We will try to figure out a new design.
> I'm not too happy about putting the ldisc part in Bluetooth though
> since it is only partly Bluetooth, it is also GPS and FM. Better could
> maybe be under char/?

After getting a better idea of what the base mfd driver does, my impression
is now that you should not register a second N_HCI line discipline at all,
but instead extend the existing line discipline with this number.

I'm not sure what happens if you need two modules that try to register
the same ldisc number, but I imagine it is not good.

Shouldn't you instead be using the drivers/bluetooth/hci_{ldisc,h4} code?

	Arnd
