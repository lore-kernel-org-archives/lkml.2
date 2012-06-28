Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2F1RxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:53:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42715 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2F1RxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:53:19 -0400
Date: Thu, 28 Jun 2012 20:53:03 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Richard Genoud <richard.genoud@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: add minimal amount of reserved erase blocks in
 Kconfig
Message-ID: <20120628205303.676fa2ea@halley>
In-Reply-To: <1340636918-7505-1-git-send-email-richard.genoud@gmail.com>
References: <1340636918-7505-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012 17:08:38 +0200 Richard Genoud <richard.genoud@gmail.com> wrote:
> diff --git a/drivers/mtd/ubi/misc.c b/drivers/mtd/ubi/misc.c
> index f6a7d7a..c2c6db0 100644
> --- a/drivers/mtd/ubi/misc.c
> +++ b/drivers/mtd/ubi/misc.c
> @@ -100,8 +100,9 @@ void ubi_calculate_reserved(struct ubi_device *ubi)
>  {
>  	ubi->beb_rsvd_level = ubi->good_peb_count/100;
>  	ubi->beb_rsvd_level *= CONFIG_MTD_UBI_BEB_RESERVE;

BTW Artem, I've always had an unresolved issue with this original
calculation... maybe you can shed some light here.

Why 'beb_rsvd_level' is set to RESERVE percent of the 'good_peb_count'?

As the device gets worn, number of 'good_peb_count' will lessen over
time - and as such, the 'beb_rsvd_level' may vary (lessen) over time.

I'd expect a fixed number of 'beb_rsvd_level' PEBs for a given mtd
partition, or more correctly, as Richard suggests, the *sum* of bad PEBs
plus the beb reserved PEBs should be constant for a partition - as I
do not expect more than a known constant of blocks to go bad during
device's (and thus, partition's) lifetime.

Regards,
Shmulik
