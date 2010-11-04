Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab0KDSBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:01:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54497 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0KDSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:01:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=cOk6C+XrE5rplV4ZPZSj1ETRErf+I4t6W+GF3UQf2bJjNh3XbMtKniDmPRoQhl1J8p
         ZJggXer1iFlHr37CVGsNbE/OJy9IZ69/N0KxCybTVR3DFbSmc86O63wN9nSMMqdfINGq
         XdgFHIh9Xk8tAreLoLiUqELmWNNYruAhxk3xI=
Date: Thu, 4 Nov 2010 14:01:07 -0400
From: mark gross <markgross@thegnar.org>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        James Bottomley <James.Bottomley@suse.de>, stable <stable@kernel.org>
Subject: Re: [PATCH] pm_qos: Fix reversed min and max
Message-ID: <20101104180107.GA20826@gvim.org>
Reply-To: markgross@thegnar.org
References: <1288852803-12356-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288852803-12356-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 11:40:03PM -0700, Colin Cross wrote:
> pm_qos_get_value had min and max reversed, causing all pm_qos
> requests to have no effect.
sorry.

Acked-by : mark <markgross@thegnar.org>
 

--mgross
 
> Change-Id: I252c764821eac8d94de57eb482c05bf6afcea15b
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: mark gross <markgross@thegnar.org>
> Cc: James Bottomley <James.Bottomley@suse.de>
> Cc: stable <stable@kernel.org>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  kernel/pm_qos_params.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index 645e541..0da2837 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -120,10 +120,10 @@ static inline int pm_qos_get_value(struct pm_qos_object *o)
>  
>  	switch (o->type) {
>  	case PM_QOS_MIN:
> -		return plist_last(&o->requests)->prio;
> +		return plist_first(&o->requests)->prio;
>  
>  	case PM_QOS_MAX:
> -		return plist_first(&o->requests)->prio;
> +		return plist_last(&o->requests)->prio;
>  
>  	default:
>  		/* runtime check for not using enum */
> -- 
> 1.7.3.1
> 
