Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0KIBaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:30:01 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53493 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab0KIB37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:29:59 -0500
Date: Mon, 8 Nov 2010 20:23:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 07/17][trivial] net, wireless: Remove unnecessary casts
 of void ptr returning alloc function return values
Message-ID: <20101109012346.GA32743@tuxdriver.com>
References: <alpine.LNX.2.00.1011082330390.23697@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011082330390.23697@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:09:13AM +0100, Jesper Juhl wrote:
> Hi,
> 
> The [vk][cmz]alloc(_node) family of functions return void pointers which
> it's completely unnecessary/pointless to cast to other pointer types since
> that happens implicitly.
> 
> This patch removes such casts from drivers/net/
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  zd_chip.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
> index 87a95bc..dfcebed 100644
> --- a/drivers/net/wireless/zd1211rw/zd_chip.c
> +++ b/drivers/net/wireless/zd1211rw/zd_chip.c
> @@ -117,8 +117,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
>  
>  	/* Allocate a single memory block for values and addresses. */
>  	count16 = 2*count;
> -	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
> -		                   GFP_KERNEL);
> +	a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)), GFP_KERNEL);
>  	if (!a16) {
>  		dev_dbg_f(zd_chip_dev(chip),
>  			  "error ENOMEM in allocation of a16\n");

kcalloc?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
