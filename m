Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778Ab2EWTck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:32:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46997 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab2EWTcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120523173617.GC4064@opensource.wolfsonmicro.com>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
	<201205221053.21792.marc@cpdesign.com.au>
	<CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
	<CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
	<20120523084945.GA4085@opensource.wolfsonmicro.com>
	<CAOMZO5DKLO5B7vbMKmXLfmR0zgVX5bVcxK22khTt=X71bL5tOQ@mail.gmail.com>
	<20120523173617.GC4064@opensource.wolfsonmicro.com>
Date: Wed, 23 May 2012 16:32:37 -0300
Message-ID: <CAOMZO5B__g46hzbMg5XSw69Fh=Gb313YJen=x8MLckyfmK8Luw@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: marc@cpdesign.com.au, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 2:36 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> The data sent should be however many bits of register address are
> specified, followed by however many padding bits are specified, followed
> by the data.  The shift there will be some combination of the padding
> and register address.

Ok, from the mc13783 datasheet:

"Both SPI ports are configured to utilize 32-bit serial data words,
using 1 read/write bit, 6 address bits, 1
null bit, and 24 data bits. The SPI ports’ 64 registers correspond to
the 6 address bits."

,and we have the struct regmap_config as:

	.reg_bits = 7,
	.pad_bits = 1,
	.val_bits = 24,

>From the bootloader I read PMIC register 0 as 0x00081000.

In the kernel all the PMIC registers accesses are read as: 0x00000810

So it looks when I read a register via SPI through regmap the register
address field is not being updated correctly (like as it was always
reading from register 0) and there is also a shift by 8 in there.
