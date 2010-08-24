Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab0HXQjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:39:44 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:49774 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754343Ab0HXQjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:39:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UnERp8kGWGkj7Mm0MjOz12MowGEMd+9g3RPvNEusfztjFxCnRtAzZhZ0jlAzRQYepP8xeEUCjR4o6GohRX7GpFrz2/qdKhkbCmd4ja4MkaT5mOfpYjnaUlrlHrxOT1Du;
Date: Tue, 24 Aug 2010 09:39:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: intel-gfx@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm/i915: Revert wait for vblank to prevent X
 refresh issues
Message-ID: <20100824093939.3166fa8a@virtuousgeek.org>
In-Reply-To: <20100824155359.GB10473@sucs.org>
References: <20100823233551.GA31920@sucs.org>
	<89kc63$hrmse5@fmsmga002.fm.intel.com>
	<20100824075741.GA11000@sucs.org>
	<8u3s8d$jcg467@orsmga001.jf.intel.com>
	<20100824084902.GA27569@sucs.org>
	<89kc63$hrqoho@fmsmga002.fm.intel.com>
	<20100824095535.GA14020@sucs.org>
	<20100824155359.GB10473@sucs.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 16:53:59 +0100
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> In commit 9d0498a2bf7455159b317f19531a3e5db2ecc9c4 20ms waits were
> converted into vblank waits. One of these caused tearing, mode detection
> and redraw issues on an EeePC 900 with a more recent intel userspace (
> http://lkml.org/lkml/2010/8/23/432 ). Restoring the 20ms wait resolves
> the issue.
> 
> Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 23157e1..116d938 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -4539,7 +4539,7 @@ struct drm_crtc *intel_get_load_detect_pipe(struct intel_encoder *intel_encoder,
>  		encoder_funcs->commit(encoder);
>  	}
>  	/* let the connector get through one full cycle before testing */
> -	intel_wait_for_vblank(dev, intel_crtc->pipe);
> +	msleep(20);
>  
>  	return crtc;
>  }

Wow, tearing, mode detection and redraw problems all because of this
line?  Maybe because we wait for a longer period here now?  Can you
check and see if we're timing out in the wait_for_vblank function?

-- 
Jesse Barnes, Intel Open Source Technology Center
