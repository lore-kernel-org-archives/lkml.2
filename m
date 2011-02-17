Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab1BQRDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:03:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62880 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1BQRDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:03:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 11/12] unicore32 machine related files: ps2 driver
Date: Thu, 17 Feb 2011 18:03:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <015701cbcdae$7d5f43f0$781dcbd0$@mprc.pku.edu.cn>
In-Reply-To: <015701cbcdae$7d5f43f0$781dcbd0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171803.15785.arnd@arndb.de>
X-Provags-ID: V02:K0:n1Y4Ta/Tb5VcOFMG/pS7Ci8oxoEw63HHQxcpdIuyn1B
 d6Z/YCmhIMJUM1RYe1ePhNlhJ/X4EiJeWgmuZWHJ8/NC7CcKXL
 jFM9TB7n8b6ky5+w1f7NxCmwVq9AVwpWgLJdHinhnm755G15XF
 1XgPp2UOEaMHzUQQlG3MppDGyukKRA2+Nu07AHQsEaUdXU4vmE
 QqorHpmR909lDSCsiB5QA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 February 2011, Guan Xuetao wrote:
> +/*
> + * Register numbers.
> + */
> +#define I8042_COMMAND_REG      ((unsigned long)&PS2_COMMAND)
> +#define I8042_STATUS_REG       ((unsigned long)&PS2_STATUS)
> +#define I8042_DATA_REG         ((unsigned long)&PS2_DATA)
> +
> +static inline int i8042_read_data(void)
> +{
> +       return inb(I8042_DATA_REG);
> +}
> +
> +static inline int i8042_read_status(void)
> +{
> +       return inb(I8042_STATUS_REG);
> +}
> +

This is not a correct way to use inb()/outb(), as far as I can tell:
PS2_COMMAND is an mmio pointer (or should be, see my other message).

inb() however is only defined on PCI/ISA PIO port numbers, which
are in the range between 0 and 65535, and typically get mapped
into the memory from the PCI driver.

	Arnd
