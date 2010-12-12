Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab0LLGhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 01:37:36 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:46034 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0LLGhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 01:37:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jKa16TMONBT/fryUkn+Zr994Adfp6Ly4bPEwrwgHQZNJ7WZC4+/peUGIY08YSQIqwp
         3OZd3bLSwTvHCXCpE7k1AQHHl7PmllWw7k3Gj3V6kHN2soycHz3NfAkKJ0wP84LLIerq
         1bDQsqnNw43UuxffYs7VrudinrsBSOjaIbB7A=
Subject: Re: [PATCH v4] mach-at91: Support for gsia18s board added
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, ryan@bluewatersys.com,
        christian.glindkamp@taskit.de, pgsellmann@portner-elektronik.at
In-Reply-To: <20101212005048.GH19897@game.jcrosoft.org>
References: <1292000411-6691-1-git-send-email-plyatov@gmail.com>
	 <20101212005048.GH19897@game.jcrosoft.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 09:37:28 +0300
Message-ID: <1292135848.2456.19.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jean-Christophe,

> On 20:00 Fri 10 Dec     , Igor Plyatov wrote:
> > The GS_IA18_S (GMS) is a carrier board from GeoSIG Ltd used with the
> > Stamp9G20 SoM from Taskit company.
> > It operate as an internet accelerometer.
> > 
> > Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> > ---
> >  arch/arm/configs/gsia18s_defconfig        |  147 +++++++
> please no new defconfig
> start to merge them

I already write that it is not possible to use same defconfig for our
board and Stamp9G20, because 69 different CONFIG_xxx options required
for our machine (compared with Portux G20 and Stamp9G20) and our options
very excessive for other devices based on the Stamp9G20.
This device for the embedded, where space constraints exists for memory
and it is required to save resources as more as possible.

> your patch contain a lots of whitespace please fix it

There is no problems with whitespace. This patch checked by
scripts/checkpatch.pl twice. It seems your mailer corrupt this patch.

> > +
> > +/*
> > + * Up to date linux/arch/arm/tools/mach-types database required to support this.
> > +MACHINE_START(GSIA18S, "GS_IA18_S")
> > +*/
> > +MACHINE_START(STAMP9G20, "GS_IA18_S")
> if you do this you must use system_rev to identify the board

I can cite Christian Glindkamp:
"And for different carrier boards, system_rev does not make sense at
all."

Please, use more testimony why it is required to use system_rev here.
Yours position does not clear for me.
You can point me to the right documentation or discussion about this
requirements in the mail archives...

> > +	.boot_params	= AT91_SDRAM_BASE + 0x100,
> > +	.timer		= &at91sam926x_timer,
> > +	.map_io		= gsia18s_map_io,
> > +	.init_irq	= init_irq,
> > +	.init_machine	= gsia18s_board_init,
> > +MACHINE_END
> Best Regards,
> J.

Best regards!
--
Igor Plyatov

