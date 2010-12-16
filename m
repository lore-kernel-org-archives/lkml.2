Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0LPWBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:01:15 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:54198 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab0LPWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:01:10 -0500
X-Auth-Info: a7lSu+P0ss6gUqlr8V0uCDDAS2p9ipJsSrF/eT6ZuKI=
Date: Thu, 16 Dec 2010 23:01:10 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Jason Lunz <lunz@acm.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Rob Landley <rob@landley.net>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
Message-ID: <20101216230110.65156c55@wker>
In-Reply-To: <20101214195124.GA6010@falooley.org>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
	<20071024011712.GA3762@falooley.org>
	<1193208689.26096.48.camel@pmac.infradead.org>
	<20071227181524.GA19051@falooley.org>
	<20071228174853.GA4252@uranus.ravnborg.org>
	<20101207072919.GA8511@falooley.org>
	<AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
	<20101207182012.GA10546@falooley.org>
	<1292343878.2538.80.camel@localhost>
	<20101214195124.GA6010@falooley.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 11:51:24 -0800
Jason Lunz <lunz@acm.org> wrote:
...
> diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
> index a9e6ba4..3d9f7e0 100644
> --- a/include/linux/mtd/map.h
> +++ b/include/linux/mtd/map.h
> @@ -388,6 +388,15 @@ static inline map_word map_word_ff(struct map_info *map)
>  	return r;
>  }
>  
> +#ifdef CONFIG_MTD_COMPLEX_MAPPINGS
> +#define map_read(map, ofs) (map)->read(map, ofs)
> +#define map_copy_from(map, to, from, len) (map)->copy_from(map, to, from, len)
> +#define map_write(map, datum, ofs) (map)->write(map, datum, ofs)
> +#define map_copy_to(map, to, from, len) (map)->copy_to(map, to, from, len)
> +
> +extern void simple_map_init(struct map_info *);
> +#define map_is_linear(map) (map->phys != NO_XIP)
> +
>  static inline map_word inline_map_read(struct map_info *map, unsigned long ofs)
>  {
>  	map_word r;
> @@ -440,15 +449,6 @@ static inline void inline_map_copy_to(struct map_info *map, unsigned long to, co
>  	memcpy_toio(map->virt + to, from, len);
>  }
>  
> -#ifdef CONFIG_MTD_COMPLEX_MAPPINGS
> -#define map_read(map, ofs) (map)->read(map, ofs)
> -#define map_copy_from(map, to, from, len) (map)->copy_from(map, to, from, len)
> -#define map_write(map, datum, ofs) (map)->write(map, datum, ofs)
> -#define map_copy_to(map, to, from, len) (map)->copy_to(map, to, from, len)
> -
> -extern void simple_map_init(struct map_info *);
> -#define map_is_linear(map) (map->phys != NO_XIP)
> -
>  #else
>  #define map_read(map, ofs) inline_map_read(map, ofs)
>  #define map_copy_from(map, to, from, len) inline_map_copy_from(map, to, from, len)

This change breaks compiling when CONFIG_MTD_COMPLEX_MAPPINGS is not
defined in the kernel configuration. Please fix!

Thanks,
Anatolij

