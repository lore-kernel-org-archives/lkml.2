Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1GNVAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:00:54 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65276 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1GNVAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110714094203.GE3455@htj.dyndns.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
	<20110714094203.GE3455@htj.dyndns.org>
Date: Thu, 14 Jul 2011 14:00:51 -0700
X-Google-Sender-Auth: ENLjH1t1trjPixU_FIregehIlYI
Message-ID: <CAE9FiQU92k-GAy3DVB4HYpn6D6_u=4T7t9_8FOGh8BLDEAKD=Q@mail.gmail.com>
Subject: Re: [PATCH 2.5/13] memblock: Use __meminit[data] instead of __init[data]
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 2:42 AM, Tejun Heo <tj@kernel.org> wrote:
> From 19ab281ed67b87a6623d725237a7333ca79f1e75 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Thu, 14 Jul 2011 11:22:16 +0200
>
> memblock will be extended to include early_node_map[], which is also
> used during memory hotplug.  Make memblock use __meminit[data] instead
> of __init[data] so that memory hotplug code can safely reference it.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  include/linux/memblock.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index aa5df9e..434b958 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -152,8 +152,8 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
>
>
>  #ifdef ARCH_DISCARD_MEMBLOCK
> -#define __init_memblock __init
> -#define __initdata_memblock __initdata
> +#define __init_memblock __meminit
> +#define __initdata_memblock __meminitdata
>  #else
>  #define __init_memblock
>  #define __initdata_memblock

that is not good. It will keep memblock.reserved related data and
functions after boot.
and those data/func are not used after slab is ready.

Thanks

Yinghai
