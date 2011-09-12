Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab1ILOv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:51:28 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39815 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163Ab1ILOv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:51:27 -0400
X-Sasl-enc: 1YtbCvEh7Lh8+GfDn3hgBlM2dT5377ryjgu1VQ59WbQs 1315839086
Date: Mon, 12 Sep 2011 16:50:17 +0200
From: Greg KH <greg@kroah.com>
To: Arvydas Sidorenko <asido4@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/staging/crystalhd/: cleanup typedefs
Message-ID: <20110912145017.GB25347@kroah.com>
References: <1315500369-11204-1-git-send-email-asido4@gmail.com>
 <1315500369-11204-2-git-send-email-asido4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315500369-11204-2-git-send-email-asido4@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 06:46:09PM +0200, Arvydas Sidorenko wrote:
> Cleans the typedef declarations in bc_dts_types.h file. Most of them aren't
> used. The ones are used are 'uint32_t' and similar ones, but I don't see the
> point of them since they are declared in stdint.h, unless some sort of embeded
> systems don't have it (no experience with it).
> So simply removing them doesn't cause any compilation errors or warnings on
> my laptop.
> 
> Signed-off-by: Arvydas Sidorenko <asido4@gmail.com>
> ---
>  drivers/staging/crystalhd/bc_dts_types.h |   41 +-----------------------------
>  1 files changed, 1 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/staging/crystalhd/bc_dts_types.h b/drivers/staging/crystalhd/bc_dts_types.h
> index d2131e7..42d7cfd 100644
> --- a/drivers/staging/crystalhd/bc_dts_types.h
> +++ b/drivers/staging/crystalhd/bc_dts_types.h
> @@ -29,29 +29,8 @@
>  #include <stdint.h>
>  #endif
>  
> -#ifndef PVOID
> -typedef void	*PVOID;
> -#endif
> -
> -#ifndef BOOL
> -typedef int	BOOL;
> -#endif
> -
>  #if defined(__KERNEL__) || defined(__LINUX_USER__)
>  
> -#ifdef __LINUX_USER__	/* Don't include these for KERNEL */
> -typedef uint32_t	ULONG;
> -typedef int32_t		LONG;
> -typedef void		*HANDLE;
> -#ifndef VOID
> -typedef void		VOID;
> -#endif
> -typedef void		*LPVOID;
> -typedef uint32_t	DWORD;
> -typedef uint32_t	UINT32;
> -typedef uint32_t	*LPDWORD;
> -typedef unsigned char	*PUCHAR;
> -
>  #ifndef TRUE
>  	#define TRUE		1
>  #endif

You can drop this too, right?

> @@ -70,28 +49,10 @@ typedef unsigned char	*PUCHAR;
>  #else
>  
>  #ifndef uint64_t
> -typedef struct _uint64_t {
> +struct _uint64_t {
>  	uint32_t low_dw;
>  	uint32_t hi_dw;
>  } uint64_t;
>  #endif

This whole thing should also be removed.

Care to redo this?

greg k-h
