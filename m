Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab2IXTAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:00:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949Ab2IXTAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:00:45 -0400
Date: Mon, 24 Sep 2012 15:00:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 3/6] dyndbg: add more info to -E2BIG log warning
Message-ID: <20120924190034.GF2492@redhat.com>
References: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
 <1348011407-24108-4-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348011407-24108-4-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 05:36:44PM -0600, Jim Cromie wrote:
> Tell user how big the attempted write was, in case its not obvious.
> This helped identify a missing flush in my stress-test script.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 43ae319..85258a8 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -693,7 +693,8 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
>  	if (len == 0)
>  		return 0;
>  	if (len > USER_BUF_PAGE - 1) {
> -		pr_warn("expected <%d bytes into control\n", USER_BUF_PAGE);
> +		pr_warn("expected <%d bytes into control, you wrote %d\n",
> +			USER_BUF_PAGE, (int) len);

The style here, I think, is generally to leave out the space, ie: (int)len.

Thanks,

-Jason

