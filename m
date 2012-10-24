Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422681Ab2JXVxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:53:51 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35582 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161325Ab2JXVxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:53:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: dave@gnu.org
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] PM/Hibernate: use rb_entry
Date: Wed, 24 Oct 2012 23:57:46 +0200
Message-ID: <6750099.YBevmVYGux@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1349086372.2721.1.camel@offbook>
References: <1349086372.2721.1.camel@offbook>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 of October 2012 12:12:52 Davidlohr Bueso wrote:
> Since the software suspend extents are organized in an rbtree, use rb_entry
> instead of container_of, as it is semantically more appropriate in order to
> get a node as it is iterated.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Applied to linux-pm.git/linux-next as v3.8 material.

Thanks,
Rafael


> ---
>  kernel/power/swap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 3c9d764..7c33ed2 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -126,7 +126,7 @@ static int swsusp_extents_insert(unsigned long swap_offset)
>  
>  	/* Figure out where to put the new node */
>  	while (*new) {
> -		ext = container_of(*new, struct swsusp_extent, node);
> +		ext = rb_entry(*new, struct swsusp_extent, node);
>  		parent = *new;
>  		if (swap_offset < ext->start) {
>  			/* Try to merge */
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
