Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab1JCM5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:57:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52895 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755246Ab1JCM5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:57:47 -0400
Message-ID: <1317646666.3866.3.camel@Joe-Laptop>
Subject: Re: [PATCH 1/2 v2] udf : enable error print in udf_read_tagged().
From: Joe Perches <joe@perches.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Date: Mon, 03 Oct 2011 05:57:46 -0700
In-Reply-To: <1317626352-29971-1-git-send-email-linkinjeon@gmail.com>
References: <1317626352-29971-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 16:19 +0900, Namjae Jeon wrote:
> And I use pr_fmt instead of printk by joe's suggestion. I try to modify totally it to pr_fmt also.
[]
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
[]
> @@ -19,18 +21,15 @@
>  #undef UDFFS_DEBUG
>  
>  #ifdef UDFFS_DEBUG
> -#define udf_debug(f, a...) \
> -do { \
> -	printk(KERN_DEBUG "UDF-fs DEBUG %s:%d:%s: ", \
> -		__FILE__, __LINE__, __func__); \
> -	printk(f, ##a); \
> -} while (0)
> +#define udf_debug(fmt, ...)	\
> +	pr_debug("DEBUG %s:%d:%s: ", fmt,	\
> +		__FILE__, __LINE__, __func__, __VA_ARGS__);

This doesn't compile properly if UDFFS_DEBUG is
#defined.

No comma should be between "DEBUG %s:%d:%s: " and fmt.


