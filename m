Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996Ab0J2JmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:42:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:54484 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab0J2JmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:42:04 -0400
Date: Fri, 29 Oct 2010 11:42:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] telephony: fix return value
In-Reply-To: <20101026195306.6a61a358@absol.kitzblitz>
Message-ID: <alpine.LNX.2.00.1010291141520.6879@pobox.suse.cz>
References: <20101026195306.6a61a358@absol.kitzblitz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Nicolas Kaiser wrote:

> If copy_from_user fails, the return value gets overwritten.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  drivers/telephony/ixj.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
> index 0d236f4..2d1280a 100644
> --- a/drivers/telephony/ixj.c
> +++ b/drivers/telephony/ixj.c
> @@ -6581,7 +6581,8 @@ static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long ar
>  	case IXJCTL_SET_FILTER:
>  		if (copy_from_user(&jf, argp, sizeof(jf))) 
>  			retval = -EFAULT;
> -		retval = ixj_init_filter(j, &jf);
> +		else
> +			retval = ixj_init_filter(j, &jf);
>  		break;
>  	case IXJCTL_SET_FILTER_RAW:
>  		if (copy_from_user(&jfr, argp, sizeof(jfr))) 

Applied, thanks Nicolas.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
