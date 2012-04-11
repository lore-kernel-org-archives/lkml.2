Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2DKWmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:42:47 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:43885 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab2DKWmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:42:45 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2012 18:42:45 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIFACxOgk8YNOMa/2dsb2JhbABDhXOhe5FEgQiCCQEBBSMEERYIBhwBEAsLCQQCAgUWCwICCQMCAQIBEQ4IHgYIBQEFAgIFFASHXgENAQusD06HCAoZgQuBFIEviW6EJYEYBIp3inWBEYRhhUqEeoMDgTg
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="173516118"
Message-ID: <4F8606B6.8010306@gmail.com>
Date: Wed, 11 Apr 2012 18:33:26 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Regression + patch] i915 / PM: System resume broken on 945GM
References: <201204120012.46826.rjw@sisk.pl>
In-Reply-To: <201204120012.46826.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Hi Chris,
>
> Unfortunately, your commit
>
> commit 7dd4906586274f3945f2aeaaa5a33b451c3b4bba
> Author: Chris Wilson<chris@chris-wilson.co.uk>
> Date:   Wed Mar 21 10:48:18 2012 +0000
>
>      drm/i915: Mark untiled BLT commands as fenced on gen2/3
>
> breaks system resume on my Toshiba Portege R500 (945GM) which hangs hard
> during or right after returning to X.
>
> The appended patch fixes the issue for me, FWIW.
>
> Thanks,
> Rafael
>
> ---
>   drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> ===================================================================
> --- linux.orig/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> +++ linux/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> @@ -498,7 +498,7 @@ pin_and_fence_object(struct drm_i915_gem
>   				if (ret)
>   					goto err_unpin;
>   			}
> -			obj->pending_fenced_gpu_access = true;
> +			obj->pending_fenced_gpu_access = need_fence;
>   		}
>   	}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Helps on Eeepc as well...

Thanks, Woody

