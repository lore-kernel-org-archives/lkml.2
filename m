Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0CRRXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:23:46 -0400
Received: from c60.cesmail.net ([216.154.195.49]:36500 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab0CRRXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:23:44 -0400
Subject: Re: [PATCH v2 1/7] wireless.h: Add STD_IW_HANDLER macro
From: Pavel Roskin <proski@gnu.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <0475f4511eedbcca7fe4e8b7fb8a457aa81358dc.1268892664.git.joe@perches.com>
References: <cover.1268892663.git.joe@perches.com>
	 <0475f4511eedbcca7fe4e8b7fb8a457aa81358dc.1268892664.git.joe@perches.com>
Content-Type: text/plain
Date: Thu, 18 Mar 2010 13:23:25 -0400
Message-Id: <1268933005.24544.16.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 23:21 -0700, Joe Perches wrote:
> Copied from orinoco, initialize a iw_handler array entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/wireless.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/wireless.h b/include/linux/wireless.h
> index 5b4c6c7..ad9f8d5 100644
> --- a/include/linux/wireless.h
> +++ b/include/linux/wireless.h
> @@ -346,6 +346,8 @@
>  #define SIOCIWFIRST	0x8B00
>  #define SIOCIWLAST	SIOCIWLASTPRIV		/* 0x8BFF */
>  #define IW_IOCTL_IDX(cmd)	((cmd) - SIOCIWFIRST)
> +#define STD_IW_HANDLER(id, func) \
> +	[IW_IOCTL_IDX(id)] = (iw_handler) func
>  
>  /* Odd : get (world access), even : set (root access) */
>  #define IW_IS_SET(cmd)	(!((cmd) & 0x1))

Three objections.

1) STD_IW_HANDLER is a poor name for a header.  The name should start
with IW, just like those above and below it.

2) Adding STD_IW_HANDLER to wireless.h and removing it from Orinoco in
separate commits might create several commits in which Orinoco may not
compile.  I think gcc would not object if you copy the definition
exactly, but I would not rely on it.  Making life miserable for
bisectors is bad - they are useful creatures.  Of course, the argument
is moot if you use a different name for the new macro.

3) Abstracting a cast is bad unless it's the whole purpose of the macro.
While Orinoco needs the cast, other drivers may not need it.  Using a
cast could prevent gcc from finding a legitimate problem.

-- 
Regards,
Pavel Roskin
