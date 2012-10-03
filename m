Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2JCJeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:34:46 -0400
Received: from shutemov.name ([176.9.204.213]:59696 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab2JCJep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:34:45 -0400
Date: Wed, 3 Oct 2012 12:35:21 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv2 3/6] staging: rts_pstor: reuse kbasename()
Message-ID: <20121003093521.GA695@shutemov.name>
References: <1349253783-21612-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1349253783-21612-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349253783-21612-4-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:43:00AM +0300, Andy Shevchenko wrote:
> The custom filename function mostly repeats the kernel's kbasename. This patch
> simplifies it. The updated filename() will not check for the '\' in the
> filenames. It seems redundant in Linux.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/rts_pstor/trace.h |   16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
> index cf60a1b..59c5686 100644
> --- a/drivers/staging/rts_pstor/trace.h
> +++ b/drivers/staging/rts_pstor/trace.h
> @@ -24,26 +24,16 @@
>  #ifndef __REALTEK_RTSX_TRACE_H
>  #define __REALTEK_RTSX_TRACE_H
>  
> +#include <linux/string.h>
> +
>  #define _MSG_TRACE
>  
>  #ifdef _MSG_TRACE
>  static inline char *filename(char *path)
>  {
> -	char *ptr;
> -
>  	if (path == NULL)
>  		return NULL;
> -
> -	ptr = path;
> -
> -	while (*ptr != '\0') {
> -		if ((*ptr == '\\') || (*ptr == '/'))
> -			path = ptr + 1;
> -		
> -		ptr++;
> -	}
> -
> -	return path;
> +	return kbasename(path);

Looks like you silentely drop const qualifier here from kbasename() return
value.

-- 
 Kirill A. Shutemov
