Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2JBRen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:34:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56508 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324Ab2JBRem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:34:42 -0400
X-Sasl-enc: w1WCj+dJqjuDn4Yi+BwkY6Qr2o1W4thAeloe1u8ore4e 1349199281
Date: Tue, 2 Oct 2012 10:34:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: Re: [PATCH 1/7] string: introduce helper to get base file name from
 given path
Message-ID: <20121002173440.GA26975@kroah.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 06:00:54PM +0300, Andy Shevchenko wrote:
> There are several places in kernel that use functionality like shell's basename
> function. Let's do it common helper for them.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  include/linux/string.h |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index b917881..b09a342 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -147,5 +147,16 @@ static inline bool strstarts(const char *str, const char *prefix)
>  
>  extern size_t memweight(const void *ptr, size_t bytes);
>  
> +/**
> + * kbasename - return the last part of a pathname.
> + *
> + * @path: path to extract the filename from.
> + */
> +static inline const char *kbasename(const char *path)
> +{
> +	const char *tail = strrchr(path, '/');
> +	return tail ? tail + 1 : path;

What happens if '/' is the last thing in the string?  You will then
point to an empty string, which I don't think all callers of this
function is assuming going to work properly (hint, the USB caller will
not...)

thanks,

greg k-h
