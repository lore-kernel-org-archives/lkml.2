Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3ABNmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:42:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab3ABNmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:42:10 -0500
Date: Wed, 2 Jan 2013 08:42:05 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] vfs: Add missing errno.h inclusion to namei.h
Message-ID: <20130102084205.2320f6b9@tlielax.poochiereds.net>
In-Reply-To: <1357133786-29587-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1357133786-29587-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Jan 2013 13:36:26 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> In current -next namei.h now include/linux/namei.h uses ESTALE but does
> not include errno.h, leading to build failures on ARM where errno.h is
> not previously implicitly included by some other header as is the case
> in some bits of ext3. Fix this by adding a direct inclusion of errno.h.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/linux/namei.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index e998c03..5a5ff57 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -2,6 +2,7 @@
>  #define _LINUX_NAMEI_H
>  
>  #include <linux/dcache.h>
> +#include <linux/errno.h>
>  #include <linux/linkage.h>
>  #include <linux/path.h>
>  

I think Ted and Stephen (cc'ed here) proposed the same patch a week or
so ago, but I'm not sure why Al hasn't pushed it yet.

-- 
Jeff Layton <jlayton@redhat.com>
