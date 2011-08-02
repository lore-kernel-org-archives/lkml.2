Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1HBUJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:09:44 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:43176 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab1HBUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:09:38 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com C324EB41A8
Date: Tue, 2 Aug 2011 22:09:34 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Julia Lawall <julia@diku.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] kernel/kfifo.c: trivial: use BUG_ON
Message-ID: <20110802200934.GB2594@thinkpad>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
 <1312281304-11847-2-git-send-email-julia@diku.dk>
 <20110802113335.GA4185@thinkpad>
 <Pine.LNX.4.64.1108021349330.24349@ask.diku.dk>
 <Pine.LNX.4.64.1108022127150.1846@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108022127150.1846@ask.diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 09:27:38PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Allow the function to return 0 when 0 elements are asked for rather than
> crashing the kernel with BUG.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Reviewed-by: Andrea Righi <andrea@betterlinux.com>

Thanks,
-Andrea

> 
> ---
>  var/julia/linuxcopy/kernel/kfifo.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff -u -p a/kernel/kfifo.c b/kernel/kfifo.c
> index 01a0700..9f928ef 100644
> --- a/var/linuxes/linux-next/kernel/kfifo.c
> +++ b/var/julia/linuxcopy/kernel/kfifo.c
> @@ -562,9 +562,6 @@ EXPORT_SYMBOL(__kfifo_to_user_r);
>  unsigned int __kfifo_dma_in_prepare_r(struct __kfifo *fifo,
>  	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
>  {
> -	if (!nents)
> -		BUG();
> -
>  	len = __kfifo_max_r(len, recsize);
>  
>  	if (len + recsize > kfifo_unused(fifo))
> @@ -586,9 +583,6 @@ EXPORT_SYMBOL(__kfifo_dma_in_finish_r);
>  unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
>  	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
>  {
> -	if (!nents)
> -		BUG();
> -
>  	len = __kfifo_max_r(len, recsize);
>  
>  	if (len + recsize > fifo->in - fifo->out)
