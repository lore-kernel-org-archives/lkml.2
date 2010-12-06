Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0LFM3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:29:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52137 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0LFM3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:29:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: Re: [PATCH v2 1/4]enable background operations for supported eMMC card
Date: Mon, 6 Dec 2010 13:28:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, cjb@laptop.org,
        akpm@linux-foundation.org, arjan@linux.intel.com, alan@linux.intel.com,
        kmpark@infradead.org
References: <20101203121338.GB18655@intel.com>
In-Reply-To: <20101203121338.GB18655@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012061328.49738.arnd@arndb.de>
X-Provags-ID: V02:K0:nMcD0JdoUINNGTXUOEs/mr0OcdkNP8CSGYGPo9TOmlj
 9IyysgOqX34Qaqqwz1HxkRj77YNp3hFWZJxubWkDBgljH2vYnh
 9nN5OvOOsWvI3TuK6buqTvWZ3Q21l6EKxNc2EpDeGnX2KaXvEx
 b78sQrnTR9EWejJFzdLRK9R1JonpKBUCNCxnDSOBYdPo8wpWzW
 0XB8EnQhuStqdPH8E5hrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 December 2010, Chuanxiao Dong wrote:
> From 984adc755cf2f7966a89e510a50f085e314fe347 Mon Sep 17 00:00:00 2001
> From: Chuanxiao Dong <chuanxiao.dong@intel.com>
> Date: Mon, 22 Nov 2010 16:31:12 +0800
> Subject: [PATCH 1/4] mmc: Enabled background operations feature if eMMC card supports

These headers don't belong into a submission. If you use git-send-email,
they get cut off automatically, otherwise just remove them as you paste
the patch into your mail client.

> Background operations is a new feature defined in eMMC4.41 standard.
> Since this feature is opertional for eMMC card, so driver only enable

s/opertional/optional/

> @@ -54,6 +54,8 @@ struct mmc_ext_csd {
>  	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
>  	unsigned int		sec_erase_mult;	/* Secure erase multiplier */
>  	unsigned int		trim_timeout;		/* In milliseconds */
> +	unsigned int		bkops:1; /* background support bit */
> +	unsigned int		bkops_en:1; /* background enable bit */
>  };

Bit fields are not encouraged for kernel internal data structures,
just use "bool" variables here.

	Arnd
