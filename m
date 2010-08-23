Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab0HWL2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:28:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55984 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0HWL2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=RceV/zLghCjbMPlw/LkIa7iWKjMV5VEvHjdmQ63k/I5CX/52lbTnMG8GkkFiuuuYwn
         Jh995KfP7ATEeWbrlCfaKsQXrl0ph0sppgrixo9NJ4RHPqp3Lse0utgxQF5FrUd8ZvkX
         cQEDsF15Li716xdYAgUA9prIa3DxXakyVVWUk=
Date: Mon, 23 Aug 2010 13:28:28 +0200
From: Dan Carpenter <error27@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] i915: remove unneed NULL checks
Message-ID: <20100823112828.GK6674@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhao Yakui <yakui.zhao@intel.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20100623170426.GB15424@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623170426.GB15424@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 07:06:22PM +0200, Dan Carpenter wrote:
> We don't need to check the list cursor in a list_for_each_entry().  It's
> always non-null.
> 

Here is another one that never got applied.  I has a sad face.  :(

regards,
dan carpenter

> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index cc8131f..8a2bdfc 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -745,7 +745,7 @@ bool intel_pipe_has_type (struct drm_crtc *crtc, int type)
>      struct drm_encoder *l_entry;
>  
>      list_for_each_entry(l_entry, &mode_config->encoder_list, head) {
> -	    if (l_entry && l_entry->crtc == crtc) {
> +	    if (l_entry->crtc == crtc) {
>  		    struct intel_encoder *intel_encoder = enc_to_intel_encoder(l_entry);
>  		    if (intel_encoder->type == type)
>  			    return true;
> @@ -3322,7 +3322,7 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
>  
>  	list_for_each_entry(encoder, &mode_config->encoder_list, head) {
>  
> -		if (!encoder || encoder->crtc != crtc)
> +		if (encoder->crtc != crtc)
>  			continue;
>  
>  		intel_encoder = enc_to_intel_encoder(encoder);
