Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab0FDP3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:29:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab0FDP3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:29:13 -0400
Date: Fri, 4 Jun 2010 08:27:23 -0700
From: Greg KH <gregkh@suse.de>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib: fix a memory leak risk
Message-ID: <20100604152723.GA25400@suse.de>
References: <4C08D498.5090503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C08D498.5090503@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 06:25:28PM +0800, Wan ZongShun wrote:
> The netlink_kernel_create failed will arouse memory leak,
> this patch is to add the 'kfree(ue_sk)' here.
> 
> Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
> 
> ---
>  lib/kobject_uevent.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
> index 59c1551..08e15f7 100644
> --- a/lib/kobject_uevent.c
> +++ b/lib/kobject_uevent.c
> @@ -378,6 +378,7 @@ static int uevent_net_init(struct net *net)
>  	if (!ue_sk->sk) {
>  		printk(KERN_ERR
>  		       "kobject_uevent: unable to create netlink socket!\n");
> +		kfree(ue_sk);

Sorry, others already sent this patch in before you, it's already in the
linux-next tree, and is going to Linus later today.

thanks,

greg k-h
