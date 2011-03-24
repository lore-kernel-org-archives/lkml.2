Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1CXLKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:10:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62340 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1CXLKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AlawyT1oACANe78PKZHWhVXeE1mJlIqgZg7iXyyM3fGQwgiYc7Q7Tw9s+JP29HiA/t
         pEi8WpIuy5bSOXJTd8GMBfHYFnWTVjaYaqfWOnYaOJ3jRxjq91u2OGKkZ/Z7IkiAPShY
         L/GJpiuc/462dtRYq9InG0F3RK1S5Wg1cVTv0=
Subject: Re: Hit BUG_ON in dma-mapping.c:425 (RFC)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        Hong XU <hong.xu@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-mtd <linux-mtd@lists.infradead.org>
In-Reply-To: <20110324092732.GA19935@n2100.arm.linux.org.uk>
References: <4D24A108.2080609@atmel.com> <4D8AFE45.8050609@atmel.com>
	 <20110324082521.GB9844@n2100.arm.linux.org.uk>
	 <1300955778.2735.68.camel@localhost>
	 <20110324092732.GA19935@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 13:08:07 +0200
Message-ID: <1300964887.2735.84.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 09:27 +0000, Russell King - ARM Linux wrote:
> The only real answer I can give is: if you want to deal with DMA, you
> absolutely must conform to the restrictions on DMA which means that you
> can't pass vmalloc addresses to the DMA API.

I see, thanks. Well, I do not see any issues with changing MTD-related
SW (JFFS2, UBI, UBIFS, etc) to use kmalloc. But this would require som
non-trivial efforts, although I believe this is doable.

Basically, we have to work with entire eraseblocks often, which may be
128KiB or 256KiB or even 512KiB nowadays. And we vmalloc the
eraseblock-sized buffers in these cases.

We could instead work with arrays of pages (or multiple pages), and then
do things like readv/writev. But this requires a brave knight who'd come
and just implemented this, or a company who'd fund someone to work on
this.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

