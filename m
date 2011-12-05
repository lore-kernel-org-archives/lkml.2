Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab1LEGrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 01:47:12 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48840 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617Ab1LEGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 01:47:11 -0500
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: shuo.liu@freescale.com
Cc: dwmw2@infradead.org, Artem.Bityutskiy@nokia.com, scottwood@freescale.com,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        leoli@freescale.com
Date: Mon, 05 Dec 2011 08:47:03 +0200
In-Reply-To: <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
	 <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323067628.2316.29.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-04 at 12:31 +0800, shuo.liu@freescale.com wrote:
> +		/*
> +		 * Freescale FCM controller has a 2K size limitation of buffer
> +		 * RAM, so elbc_fcm_ctrl->buffer have to be used if writesize
> +		 * of chip is greater than 2048.
> +		 * We malloc a large enough buffer (maximum page size is 16K).
> +		 */
> +		elbc_fcm_ctrl->buffer = kmalloc(1024 * 16 + 1024, GFP_KERNEL);
> +		if (!elbc_fcm_ctrl->buffer) {
> +			dev_err(dev, "failed to allocate memory\n");
> +			mutex_unlock(&fsl_elbc_nand_mutex);
> +			ret = -ENOMEM;
> +			goto err;
> +		}

Sorry for returning to this again and agian - I do not have time to dig
suggest you the right solutions on the one hand, you do not provide me a
good answer on the other hand (or I forgot?).

16KiB pages do not even exist I believe. And you kmalloc 33KiB or RAM
although in most cases you need only 5KiB. I think this is wrong - what
is the very strong reason of wasting RAM you have?

Why you cannot allocate exactly the required amount of RAM after
'nand_scan_ident()' finishes and you know the page size?

Artem.

