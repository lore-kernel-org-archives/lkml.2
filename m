Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0DCUrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 16:47:24 -0400
Received: from 8bytes.org ([88.198.83.132]:44158 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab0DCUrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 16:47:19 -0400
Date: Sat, 3 Apr 2010 22:47:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Dan Carpenter <error27@gmail.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] dma-debug: off by one issue
Message-ID: <20100403204717.GS24846@8bytes.org>
References: <20100402112843.GI5265@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402112843.GI5265@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 02:28:43PM +0300, Dan Carpenter wrote:
> We need to reserve the last character for the NULL terminator.

The character is already reserved by the user-to-kernel copy earlier in
the function.

	Joerg

> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index ba8b670..01e6427 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -570,7 +570,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
>  	 * Now parse out the first token and use it as the name for the
>  	 * driver to filter for.
>  	 */
> -	for (i = 0; i < NAME_MAX_LEN; ++i) {
> +	for (i = 0; i < NAME_MAX_LEN - 1; ++i) {
>  		current_driver_name[i] = buf[i];
>  		if (isspace(buf[i]) || buf[i] == ' ' || buf[i] == 0)
>  			break;
