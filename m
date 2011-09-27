Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab1I0QSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:18:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40243 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234Ab1I0QSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:18:31 -0400
Message-ID: <1317140310.16786.2.camel@Joe-Laptop>
Subject: Re: [PATCH] udf: enable error print in udf_read_tagged().
From: Joe Perches <joe@perches.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Date: Tue, 27 Sep 2011 09:18:30 -0700
In-Reply-To: <1317138382-1966-1-git-send-email-linkinjeon@gmail.com>
References: <1317138382-1966-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.92- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 00:46 +0900, Namjae Jeon wrote:
> While reading metadata, if a problem occurs, Print out only one of the five case.(It also does not show a checksum properly.)
[]
> diff --git a/fs/udf/misc.c b/fs/udf/misc.c
[]
> @@ -211,7 +212,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
>  
>  	bh = udf_tread(sb, block);
>  	if (!bh) {
> -		udf_debug("block=%d, location=%d: read failed\n",
> +		printk(KERN_ERR "block=%d, location=%d: read failed\n",

The other printk in this module uses a "udf: " prefix.

I suggest that
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
is added before any include and these
conversions use pr_err() instead.


