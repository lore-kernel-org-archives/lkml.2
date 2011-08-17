Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1HQUmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:42:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab1HQUjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch 13/36] Hexagon: Support dynamic module loading.
Date: Wed, 17 Aug 2011 21:41:37 +0200
Message-ID: <1800933.OQ1SvESjJ0@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163521.072192837@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163521.072192837@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:EQ/A8qtpWNxsBZF/WWg54Azv/dWJCOjOFQ0C55KBXzI
 5L+yl8PiLAnDqRuAA5+hOZ01RPtsnyjtth+vAwMPygTwMSPBwn
 OryY7bquPQVb5L477SXKMHzCLSvrINeSzPC0UHw9RmbUaC4eJx
 /jwyCh8R1fgg2uqI3Yjy1xgR572F+QMAGZUhXY+u6o0mZWIIK+
 R98VlaUD2QFbbrLmAyvHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:10 Richard Kuo wrote:
> + * module_alloc - wrapper around vmalloc
> + * @size - memory size to vmalloc
> + */
> +void *module_alloc(unsigned long size)
> +{
> +       if (size == 0)
> +               return NULL;
> +       return vmalloc_exec(size);
> +}
> +
> +/*
> + * module_free - free memory returned from module_alloc
> + * @mod - pointer to module?
> + * @module_region - pointer to module region?
> + */
> +void module_free(struct module *mod, void *module_region)
> +{
> +       vfree(module_region);
> +}
> +
> +/*
> + * module_finalize - perform platform-dependent fixups.
> + */
> +int module_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
> +                       struct module *me)
> +{
> +       return 0;
> +}
> +
> +/*
> + * module_arch_cleanup - Any cleanup needed with module
> + * @mod - pointer to module
> + * @module_region - pointer to module region
> + */
> +void module_arch_cleanup(struct module *mod)
> +{
> +}

These are the default implementations that are now (as of 3.1) provided
by common code, so you can just omit your own definitions.

	Arnd
