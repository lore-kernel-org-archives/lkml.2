Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab2JRTyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:54:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab2JRTyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:54:35 -0400
Date: Thu, 18 Oct 2012 15:20:08 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynamic_debug: Remove unnecessary __used
Message-ID: <20121018192007.GB3703@redhat.com>
References: <1350587223.5652.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350587223.5652.4.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:07:03PM -0700, Joe Perches wrote:
> The __used attribute prevents gcc from eliminating
> unnecessary, otherwise optimized away, metadata for
> debugging logging messages.
> 
> Remove the __used attribute.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/dynamic_debug.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> index c18257b..6dd4787 100644
> --- a/include/linux/dynamic_debug.h
> +++ b/include/linux/dynamic_debug.h
> @@ -61,7 +61,7 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
>  			 const char *fmt, ...);
>  
>  #define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> -	static struct _ddebug __used __aligned(8)		\
> +	static struct _ddebug  __aligned(8)			\
>  	__attribute__((section("__verbose"))) name = {		\
>  		.modname = KBUILD_MODNAME,			\
>  		.function = __func__,				\
> 
> 

Greg, Pls pull this.

Acked-by: Jason Baron <jbaron@redhat.com>
