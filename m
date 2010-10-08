Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0JHRMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:12:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42306 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab0JHRMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:12:13 -0400
Date: Fri, 8 Oct 2010 11:12:10 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: sparclinux@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2 v2] of: move phandle/ihandle into types.h and
 export to userspace
Message-ID: <20101008171210.GE3863@angua.secretlab.ca>
References: <20101008004354.13b5b254@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008004354.13b5b254@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 12:43:54AM -0700, Andres Salomon wrote:
> 
> We need phandle for some exported sparc headers; of.h isn't an
> exported header, and it would be silly to export it when all we
> really need is one or two types from it.  Also, later patches
> use phandle in structs that are exported to userspace, so export
> a __kernel_phandle type.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Looks okay to me.  I'm build testing it now on powerpc and
microblaze.  If davem agrees, then I'll pick it up into my
devicetree-next branch.

Question though; since sparc userspace is the only user of this,
should the types.h header avoid exposing it on non-sparc?

g.

> ---
>  include/linux/of.h    |    3 ---
>  include/linux/types.h |    7 +++++++
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index cad7cf0..db184dc 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -25,9 +25,6 @@
>  
>  #ifdef CONFIG_OF
>  
> -typedef u32 phandle;
> -typedef u32 ihandle;
> -
>  struct property {
>  	char	*name;
>  	int	length;
> diff --git a/include/linux/types.h b/include/linux/types.h
> index 01a082f..67a034a 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -178,10 +178,17 @@ typedef __u64 __bitwise __be64;
>  typedef __u16 __bitwise __sum16;
>  typedef __u32 __bitwise __wsum;
>  
> +/* Basic openboot/openfirmware types */
> +typedef __u32 __kernel_phandle;
> +typedef __u32 __kernel_ihandle;
> +
>  #ifdef __KERNEL__
>  typedef unsigned __bitwise__ gfp_t;
>  typedef unsigned __bitwise__ fmode_t;
>  
> +typedef __kernel_phandle phandle;
> +typedef __kernel_ihandle ihandle;
> +
>  #ifdef CONFIG_PHYS_ADDR_T_64BIT
>  typedef u64 phys_addr_t;
>  #else
> -- 
> 1.5.6.5
> 
