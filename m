Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1FSS6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 14:58:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab1FSS6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 14:58:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 05/19] OpenRISC: Build infrastructure
Date: Sun, 19 Jun 2011 20:57:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-6-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-6-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192057.47617.arnd@arndb.de>
X-Provags-ID: V02:K0:i+GaEhuznQdbciioRR/h7MAH1iKL8R4rQpuLSVoPU8A
 9wnwN/ONspVt/lUqRvHGBfhFH4K+2rojboCuG6L5RtgR/w1img
 SC2LtdVjyJN6jgKPxo0id6qAk3di3s+2jwfAXLrydZ7XmQpwnI
 Qeh19VbGlmAjrEmPtzhraQT9Bcbw8aAQVu/RLLND2y+oSiDjHJ
 kDLKv18LGObnY+kXmsNmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:43:31 Jonas Bonn wrote:

> +config MMU
> +	bool
> +	default y

You can turn all the 'bool, default y' into 'def_bool y'

> +config GENERIC_CALIBRATE_DELAY
> +	bool
> +	default y

Do you need it? If you always pass the timer frequency in the
device tree, you can skip the calibrate_delay portion of the boot
process and at the same time get a more accurate time representation.

> +config FRAME_POINTER
> +       bool
> +       default y

Many architectures don't need this any more. Are you sure you still do?

> +choice
> +	prompt "Subarchitecture"
> +	default OR1K_1200
> +
> +config OR1K_1200
> +	bool "OR1200"
> +	help
> +	  Generic OpenRISC 1200 architecture
> +
> +endchoice

This seems pointless as long as there is only a single one. If you don't
plan to add a second one in the near future, just leave the menu out.

> +CONFIG_EMBEDDED=y

Why set CONFIG_EMBEDDED? I don't see any options depending on that being
set.

> +CONFIG_PREEMPT=y

Setting PREEMPT in the defconfig is fairly unusual.

	Arnd
