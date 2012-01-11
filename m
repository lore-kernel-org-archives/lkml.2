Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2AKUgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:36:55 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37763 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab2AKUgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:36:54 -0500
Date: Wed, 11 Jan 2012 12:36:51 -0800
From: Kees Cook <keescook@chromium.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, tyler.hicks@canonical.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ecryptfs: Improve metatdata read failure logging
Message-ID: <20120111203651.GR2618@outflux.net>
References: <1326301242-5817-1-git-send-email-tim.gardner@canonical.com>
 <1326301242-5817-2-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326301242-5817-2-git-send-email-tim.gardner@canonical.com>
Organization: Chromium
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 06:00:41PM +0100, Tim Gardner wrote:
> There are 3 read failure cases in ecryptfs_read_metadata(), but only 2
> of them are uniquely noted by kernel log messages. This patch
> identifies and logs each read failure case. It also correctly interprets
> a negative return value from ecryptfs_read_lower().
> 
> Removes unnecessary variable initialization.
> 
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: Tyler Hicks <tyler.hicks@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

I always like more verbose error reporting. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

> +		printk(KERN_ERR "%s: Could not read %u bytes\n",
> +			__func__, crypt_stat->extent_size);

I wonder if eCryptfs in general might want to consider using the "pr_fmt"
and "pr_*" macros to do printk handling:

#define pr_fmt(fmt) __func__ ": " fmt

...

	pr_err("Could not read %u bytes\n", crypt_stat->extent_size);


-Kees

-- 
Kees Cook
