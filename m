Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab1EMXZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:25:30 -0400
Received: from kroah.org ([198.145.64.141]:42910 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758836Ab1EMXZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:25:27 -0400
Date: Fri, 13 May 2011 16:14:52 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] debugfs: Silence DEBUG_STRICT_USER_COPY_CHECKS=y
 warning
Message-ID: <20110513231452.GA1803@kroah.com>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
 <1305244212-19183-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305244212-19183-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 04:50:07PM -0700, Stephen Boyd wrote:
> Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following
> warning:
> 
> In file included from arch/x86/include/asm/uaccess.h:573,
>                  from include/linux/uaccess.h:5,
>                  from include/linux/highmem.h:7,
>                  from include/linux/pagemap.h:10,
>                  from fs/debugfs/file.c:18:
> In function 'copy_from_user',
>     inlined from 'write_file_bool' at fs/debugfs/file.c:435:
> arch/x86/include/asm/uaccess_64.h:65: warning: call to
> 'copy_from_user_overflow' declared with attribute warning:
> copy_from_user() buffer size is not provably correct
> 
> presumably due to buf_size being signed causing GCC to fail to
> see that buf_size can't become negative.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  fs/debugfs/file.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index 89d394d..7ead5b8 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -428,7 +428,7 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
>  			       size_t count, loff_t *ppos)
>  {
>  	char buf[32];
> -	int buf_size;
> +	size_t buf_size;
>  	u32 *val = file->private_data;

What tree did you make this against?  It doesn't apply to the linux-next
tree :(

Anyway, I can hand edit it, not that big of a deal, but be more careful
the next time around.

greg k-h
