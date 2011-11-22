Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab1KVVE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:04:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55745 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab1KVVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:04:28 -0500
Subject: Re: [PATCH v3 3/3] mtd/nand : workaround for Freescale FCM to
 support large-page Nand chip
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: b35362@freescale.com
Cc: dwmw2@infradead.org, Artem.Bityutskiy@nokia.com,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        leoli@freescale.com, scottwood@freescale.com,
        Liu Shuo <Shuo.Liu@freescale.com>,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>
Date: Tue, 22 Nov 2011 23:04:18 +0200
In-Reply-To: <1321349355-1639-3-git-send-email-b35362@freescale.com>
References: <1321349355-1639-1-git-send-email-b35362@freescale.com>
	 <1321349355-1639-2-git-send-email-b35362@freescale.com>
	 <1321349355-1639-3-git-send-email-b35362@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321995862.2222.2.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 17:29 +0800, b35362@freescale.com wrote:
> +               /*
> +                * Freescale FCM controller has a 2K size limitation of buffer
> +                * RAM, so elbc_fcm_ctrl->buffer have to be used if writesize
> +                * of chip is greater than 2048.
> +                * We malloc a large enough buffer at this point, because we
> +                * don't know writesize before calling nand_scan(). We will
> +                * re-malloc later if needed.
> +                */
> +               elbc_fcm_ctrl->buffer = kmalloc(4096 * 6, GFP_KERNEL);
> +               if (!elbc_fcm_ctrl->buffer)
> +                       return -ENOMEM; 

Why 4096*6? Judging from the comment it should be 4096.

Artem.

