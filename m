Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314Ab2FGSiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:38:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19469 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760930Ab2FGSis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:38:48 -0400
Date: Thu, 7 Jun 2012 14:31:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: dan.magenheimer@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] mm: frontswap: remove unnecessary check during
 initialization
Message-ID: <20120607183145.GB9472@phenom.dumpdata.com>
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
 <1338980115-2394-7-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338980115-2394-7-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:55:11PM +0200, Sasha Levin wrote:

Could you explain in the git commit why it is unnecessary?
I am pretty sure I know - it is b/c frontswap_init already
does the check, but the git commit should mention it.

> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  mm/frontswap.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/frontswap.c b/mm/frontswap.c
> index f2f4685..bf99c7d 100644
> --- a/mm/frontswap.c
> +++ b/mm/frontswap.c
> @@ -89,8 +89,7 @@ void __frontswap_init(unsigned type)
>  	BUG_ON(sis == NULL);
>  	if (sis->frontswap_map == NULL)
>  		return;
> -	if (frontswap_enabled)
> -		frontswap_ops.init(type);
> +	frontswap_ops.init(type);
>  }
>  EXPORT_SYMBOL(__frontswap_init);
>  
> -- 
> 1.7.8.6
