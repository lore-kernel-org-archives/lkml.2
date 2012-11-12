Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2KLNx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:53:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab2KLNxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:53:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet.Gupta1@synopsys.com
Subject: Re: [RFC Patch v1 37/55] ARC: dynamic loadable module support
Date: Mon, 12 Nov 2012 13:53:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-7-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352720953-24321-7-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121353.15314.arnd@arndb.de>
X-Provags-ID: V02:K0:cq4MCLJEN2V7mMoqktg0a6k/0WiZqb32nFQMVYv2gjs
 t7F/vwR3gndrl5IyX/n8kuua6Z1a9WUv7h7g0AkwPZ8ZjO026r
 lkzbFqt1jchrmxt4/G43u1W60hN7vRyJjpt6FMpr8Fe9mS/HhG
 P9ovWEr3+3u4FyJQE0++214NiFB+6JVmCdBrZkiwGffYI8NC4K
 U7l9/ckGpXwOPFEuaiv+Z45BiRCwzBDvQoGAdpjpfb/0phAtcU
 1wkNNP+vWle5H84onh1QQ+srZednNDFIpC7iDjvHNOsXxev8zD
 93yAxj5QcJI4wiV1/vhlJzw6B1LDIV85HSaPcNxM8IcVR3Ihz8
 wgYZv4q02voT/EQQe+d4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
> +void *module_alloc(unsigned long size)
> +{
> +       if (size == 0)
> +               return NULL;
> +
> +       return vmalloc(size);
> +
> +}
> +
> +void module_free(struct module *module, void *region)
> +{
> +       vfree(region);
> +}
> +
> +int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
> +                             char *secstr, struct module *mod)
> +{
> +    return 0;
> +}
> +
> +void module_arch_cleanup(struct module *mod)
> +{
> +}
> +
> +int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
> +                   struct module *mod)
> +{
> +    return 0;
> +} 

All of these are identical to the default implementation in kernel/module.c
and you can simply drop your own definitions.

	Arnd
