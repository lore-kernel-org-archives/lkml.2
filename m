Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0E1GYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:24:43 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:65259 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751209Ab0E1GYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:24:41 -0400
Date: Fri, 28 May 2010 16:24:26 +1000
From: David McCullough <david_mccullough@mcafee.com>
To: Mike Frysinger <vapier@gentoo.org>
CC: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH 2/2 v2] FLAT: tweak default stack alignment
Message-ID: <20100528062425.GB20365@mcafee.com>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
 <1274863506-14168-2-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1274863506-14168-2-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 May 2010 06:24:27.0461 (UTC) FILETIME=[6C6E7750:01CAFE2E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin Mike Frysinger lays it down ...
> The recent commit 1f0ce8b3dd667dca7 which moved the ARCH_SLAB_MINALIGN
> default into the global header inadvertently broke FLAT for a bunch of
> systems.  Blackfin systems now fail on any FLAT exec with:
> Unable to read code+data+bss, errno 14
> When your /init is a FLAT binary, obviously this can be annoying ;).
> 
> This stems from the alignment usage in the FLAT loader.  The behavior
> before was that FLAT would default to ARCH_SLAB_MINALIGN only if it was
> defined, and this was only defined by arches when they wanted a larger
> alignment value.  Otherwise it'd default to pointer alignment.  Arguably,
> this is kind of hokey that the FLAT is semi-abusing defines it shouldn't.
> 
> But let's ignore that and simply ignore min alignment values of 0.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David McCullough <david_mccullough@mcafee.com>

Cheers,
Davidm

> ---
> v2
> 	- split changes & document better
> 
>  fs/binfmt_flat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index b865622..4959a0a 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -68,7 +68,7 @@
>   * Here we can be a bit looser than the data sections since this
>   * needs to only meet arch ABI requirements.
>   */
> -#ifdef ARCH_SLAB_MINALIGN
> +#if defined(ARCH_SLAB_MINALIGN) && ARCH_SLAB_MINALIGN != 0
>  #define FLAT_STACK_ALIGN	(ARCH_SLAB_MINALIGN)
>  #else
>  #define FLAT_STACK_ALIGN	(sizeof(void *))
> -- 
> 1.7.1
> 
> 
> 

-- 
David McCullough,      david_mccullough@mcafee.com,  Ph:+61 734352815
McAfee - SnapGear      http://www.mcafee.com         http://www.uCdot.org
