Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1HPTmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:42:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1HPTmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:42:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean Delvare <khali@linux-fr.org>, Hans Berglund <hb@spacetec.no>,
        Jonas Bonn <jonas@southpole.se>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: I2C_ELEKTOR should depend on HAS_IOPORT
Date: Tue, 16 Aug 2011 21:42:06 +0200
Message-ID: <4991605.b7BYCfYE3S@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CAMuHMdUk_xTwGbhG0MHkS-8rkF76b1fg193pPcs+9MVyB-qHQw@mail.gmail.com>
References: <1312802446-19154-1-git-send-email-geert@linux-m68k.org> <20110816195033.014f302b@endymion.delvare> <CAMuHMdUk_xTwGbhG0MHkS-8rkF76b1fg193pPcs+9MVyB-qHQw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VKB0y8E4BztXQoVONyJsUzRnSOXtFPHY86RrNGq0Kut
 vVCI7IJtWRQbhRCGtPRfO6sI/XUpIzlQdcMbZwbHZ1ywEsZXJj
 1EbJkVHeOlY7EtpcI4T6BhbaOeU0Lkg9ZfFgvAR25gLmPcyOBX
 Mjm78EKc4RQT717LPrEh6ILTn5B8oL65pixgY7AceMLnyemJUN
 Cxs4jAvn6m8YTiMAY0/ZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 August 2011 21:14:42 Geert Uytterhoeven wrote:
> >>  config I2C_ELEKTOR
> >>       tristate "Elektor ISA card"
> >> -     depends on ISA && BROKEN_ON_SMP
> >> +     depends on ISA && HAS_IOPORT && BROKEN_ON_SMP
> >>       select I2C_ALGOPCF
> >>       help
> >>         This supports the PCF8584 ISA bus I2C adapter.  Say Y if you own
> >
> > How can ISA be set if HAS_IOPORT is not? This shouldn't be allowed.
> 
> It's always been like that. With CONFIG_ISA, we have inb() and friends. But not
> ioport_map(), which was introduced more recently.

Right. BTW, I'd really like to change that once I've picked up and fixed the
use of inb() in 8250.c. I think we should change CONFIG_HAS_IOPORT to mean
that inb(), ioport_resource and /proc/ioports are available, while a new
CONFIG_HAS_IOPORT_MAP can then replace the current CONFIG_HAS_IOPORT symbol.

	Arnd
