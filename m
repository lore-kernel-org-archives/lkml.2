Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2HONaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:30:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57522 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2HONaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:30:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 04/31] arm64: MMU definitions
Date: Wed, 15 Aug 2012 13:30:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-5-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-5-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151330.02112.arnd@arndb.de>
X-Provags-ID: V02:K0:kgBlLMM7u01LwoQdqATMWEHGeT7fuLSXlNkkvXoBAEH
 TcPFyzJQwE7c9KVF76W6wPM9CtzNasCrgBx1naLLJGgpOnR7NT
 OXaQSedSmki1sU4bNYXi06iJFJFRisyMfGUNMBquI/TDv0VRoA
 +rBJqJpmY/Bh8C45S6/vYZuJfTC4dTj0EoDskDnI08ggVKbbLj
 xi9IZ9ok2Hq3x/yVofMOV5NYOTAF7BOsuCsIcnWUjjeP7vZzLv
 LfRRUN5um1W/5qJIs8s7hbo4/jM4le7msrI+2ksHY0TVe72Uyr
 gdJhK1xfI+9EajIuBKh1BqeU+8KmwwWQLn31r0ma5ZuAzwtSbv
 6ckdXZTFbOasCMg/WGrU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
>
> +/*
> + * TCR flags.
> + */
> +#define TCR_TxSZ(x)		(((64 - (x)) << 16) | ((64 - (x)) << 0))
> +#define TCR_IRGN_NC		((0 << 8) | (0 << 24))
> +#define TCR_IRGN_WBWA		((1 << 8) | (1 << 24))
> +#define TCR_IRGN_WT		((2 << 8) | (2 << 24))
> +#define TCR_IRGN_WBnWA		((3 << 8) | (3 << 24))
> +#define TCR_IRGN_MASK		((3 << 8) | (3 << 24))
> +#define TCR_ORGN_NC		((0 << 10) | (0 << 26))
> +#define TCR_ORGN_WBWA		((1 << 10) | (1 << 26))
> +#define TCR_ORGN_WT		((2 << 10) | (2 << 26))
> +#define TCR_ORGN_WBnWA		((3 << 10) | (3 << 26))
> +#define TCR_ORGN_MASK		((3 << 10) | (3 << 26))
> +#define TCR_SHARED		((3 << 12) | (3 << 28))
> +#define TCR_TG0_64K		(1 << 14)
> +#define TCR_TG1_64K		(1 << 30)
> +#define TCR_IPS_40BIT		(2 << 32)
> +#define TCR_ASID16		(1 << 36)
> +

As a matter of coding style, I would much prefer tables like this to be
written as

#define TCR_IRGN_MASK		0x0000000003000300
#define TCR_IRGN_WBnWA		0x0000000003000300
#define TCR_IRGN_WT		0x0000000002000200
#define TCR_IRGN_WBWA		0x0000000001000100
#define TCR_IRGN_NC		0x0000000000000000

#define TCR_ORGN_MASK		0x000000000c000c00
#define TCR_ORGN_WBnWA		0x000000000c000c00
#define TCR_ORGN_WT		0x0000000008000800
#define TCR_ORGN_WBWA		0x0000000004000400
#define TCR_ORGN_NC		0x0000000000000000

The advantage of this is that you can visually compare the bitmasks
to a hex dump, and if you are suffering from endian-confused documentation
authors, there is no ambiguity about which end of the word is bit zero.

	Arnd
