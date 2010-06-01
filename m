Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0FAVCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:02:24 -0400
Received: from complete.lackof.org ([198.49.126.79]:37622 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab0FAVCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:02:22 -0400
Date: Tue, 1 Jun 2010 15:02:12 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH 14/21] drivers/parisc/iosapic.c: Remove unnecessary
	kzalloc cast
Message-ID: <20100601210212.GA19544@lackof.org>
References: <cover.1275360951.git.joe@perches.com> <ba7d48df75ca37c39b0e519921c116a617e71db7.1275360951.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba7d48df75ca37c39b0e519921c116a617e71db7.1275360951.git.joe@perches.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 08:23:16PM -0700, Joe Perches wrote:
> Convert kzalloc to kcalloc
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> ---
>  drivers/parisc/iosapic.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
> index c768367..3e6f56c 100644
> --- a/drivers/parisc/iosapic.c
> +++ b/drivers/parisc/iosapic.c
> @@ -891,8 +891,8 @@ void *iosapic_register(unsigned long hpa)
>  	isi->isi_version = iosapic_rd_version(isi);
>  	isi->isi_num_vectors = IOSAPIC_IRDT_MAX_ENTRY(isi->isi_version) + 1;
>  
> -	vip = isi->isi_vector = (struct vector_info *)
> -		kzalloc(sizeof(struct vector_info) * isi->isi_num_vectors, GFP_KERNEL);
> +	vip = isi->isi_vector = kcalloc(isi->isi_num_vectors,
> +					sizeof(struct vector_info), GFP_KERNEL);
>  	if (vip == NULL) {
>  		kfree(isi);
>  		return NULL;
> -- 
> 1.7.0.3.311.g6a6955
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
