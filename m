Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0E2UHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 16:07:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56779 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab0E2UG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 16:06:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [patch] complain when users abuse the pm_qos API
Date: Sat, 29 May 2010 22:08:04 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20100529045027.GE11600@gvim.org>
In-Reply-To: <20100529045027.GE11600@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005292208.04309.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 May 2010, mark gross wrote:
> The following patch is to help clean up API abusers of pm_qos where
> they call update_request before registering a request.
> 
> --mgross
> 
> --Signed-off-by: markgross <markgross@thegnar.org>

Will there be a big issue if I push this during the next merge window?

Rafael


> From a0813007ddc7b72cb3da7a533fefba9889aab1d8 Mon Sep 17 00:00:00 2001
> From: mgross <mgross@mgross-desktop.(none)>
> Date: Fri, 28 May 2010 21:36:06 -0700
> Subject: [PATCH] complain when users abuse the pm_qos API by updating a request that
>  isn't registered yet.
> 
> ---
>  kernel/pm_qos_params.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index f42d3f7..8e55bf1 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -266,6 +266,10 @@ void pm_qos_update_request(struct pm_qos_request_list *pm_qos_req,
>  		spin_unlock_irqrestore(&pm_qos_lock, flags);
>  		if (pending_update)
>  			update_target(pm_qos_req->pm_qos_class);
> +	} else {
> +		WARN(true, "pm_qos: updating an unregistered request "
> +				"does nothing");
> +		dump_stack();
>  	}
>  }
>  EXPORT_SYMBOL_GPL(pm_qos_update_request);
> 

