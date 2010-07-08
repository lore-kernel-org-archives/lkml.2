Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab0GHGLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 02:11:01 -0400
Received: from smtp.nokia.com ([192.100.122.233]:48842 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0GHGLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 02:11:00 -0400
Subject: Re: [PATCH v2 17/26] MTD: Nand: Add JZ4740 NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
In-Reply-To: <1276924111-11158-18-git-send-email-lars@metafoo.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
	 <1276924111-11158-18-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 09:06:54 +0300
Message-ID: <1278569214.12733.38.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jul 2010 06:10:47.0729 (UTC) FILETIME=[4EC50A10:01CB1E64]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-19 at 07:08 +0200, Lars-Peter Clausen wrote:
> diff --git a/include/linux/mtd/jz4740_nand.h b/include/linux/mtd/jz4740_nand.h
> new file mode 100644
> index 0000000..379f9b6
> --- /dev/null
> +++ b/include/linux/mtd/jz4740_nand.h
> @@ -0,0 +1,34 @@
> +/*
> + *  Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
> + *  JZ4740 SoC NAND controller driver
> + *
> + *  This program is free software; you can redistribute	 it and/or modify it
> + *  under  the terms of	 the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the	License, or (at your
> + *  option) any later version.
> + *
> + *  You should have received a copy of the  GNU General Public License along
> + *  with this program; if not, write  to the Free Software Foundation, Inc.,
> + *  675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +#ifndef __JZ_NAND_H__
> +#define __JZ_NAND_H__
> +
> +#include <linux/mtd/nand.h>
> +#include <linux/mtd/partitions.h>
> +
> +struct jz_nand_platform_data {
> +	int			num_partitions;
> +	struct mtd_partition	*partitions;
> +
> +	struct nand_ecclayout	*ecc_layout;
> +
> +	unsigned int busy_gpio;
> +
> +	void (*ident_callback)(struct platform_device *, struct nand_chip *,
> +				struct mtd_partition **, int *num_partitions);
> +};
> +
> +#endif

Do you really have to add your platform data strucutre to
"inlculde/mtd" ? That is quite global namespace, and ideally only things
like user-space interface and "public" interface of the MTD subsystem
should live there.

Can you keep this somewhere in mips architecture directory?
-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

