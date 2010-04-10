Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0DJQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 12:25:57 -0400
Received: from waste.org ([173.11.57.241]:58671 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab0DJQZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 12:25:56 -0400
Subject: Re: [PATCH] random: Forbid llseek on random chardev
From: Matt Mackall <mpm@selenic.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <1270909064-7845-1-git-send-regression-fweisbec@gmail.com>
References: <1270909064-7845-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Apr 2010 11:25:50 -0500
Message-ID: <1270916750.28124.23.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-10 at 16:17 +0200, Frederic Weisbecker wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Seeking on /dev/random and /dev/urandom is pointless.

It is indeed pointless, though that doesn't mean no one does it. 
Forbidding a no-op seems a rather unfriendly way to fix this.

> Using generic_file_llseek means we no longer need to
> take the BKL if anyone tries to seek on these.

Comment doesn't match the patch?

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  drivers/char/random.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 2fd3d39..513c685 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1169,6 +1169,7 @@ const struct file_operations random_fops = {
>  	.poll  = random_poll,
>  	.unlocked_ioctl = random_ioctl,
>  	.fasync = random_fasync,
> +	.open = nonseekable_open,
>  };
>  
>  const struct file_operations urandom_fops = {
> @@ -1176,6 +1177,7 @@ const struct file_operations urandom_fops = {
>  	.write = random_write,
>  	.unlocked_ioctl = random_ioctl,
>  	.fasync = random_fasync,
> +	.open = nonseekable_open,
>  };
>  
>  /***************************************************************



-- 
http://selenic.com : development and support for Mercurial and Linux


