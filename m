Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab1EaQ6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:58:43 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:41172 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752315Ab1EaQ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:58:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=i/mgaP+QUGFmr/rs+8Lj23WplEEJ9Rb+iCnzMXNgkXN5wbPDxecphCnJSvMsIsEdoWOkW5LR9wei1yG0EZMNAMiucBo3vluzxAVaUyLFhucisN+5i0pASqvv3prLJdXq;
Date: Tue, 31 May 2011 09:58:23 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jason Stubbs <jasonbstubbs@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: fix regression after clock gating init split
Message-ID: <20110531095823.4af74109@jbarnes-desktop>
In-Reply-To: <201105281426.49040.jasonbstubbs@gmail.com>
References: <201105272344.20084.jasonbstubbs@gmail.com>
	<yunaae8j5dg.fsf@aiko.keithp.com>
	<201105281426.49040.jasonbstubbs@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011 14:26:48 +1000
Jason Stubbs <jasonbstubbs@gmail.com> wrote:

> From: Jason Stubbs <jasonbstubbs@gmail.com>
> 
> During the refactoring in revision 6067aaeadb5b3df26f27ac827256b1ef01e674f5,
> the intel_enable_clock_gating was split up into several functions that are
> then called indirectly. However, which function to call was not specified for
> the IS_PINEVIEW() case. This patch specifies the correct gating function.
> 
> Signed-off-by: Jason Stubbs <jasonbstubbs@gmail.com>
> ---
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index f553ddf..bb1b59b 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7675,6 +7675,7 @@ static void intel_init_display(struct drm_device *dev)
>  			dev_priv->display.update_wm = NULL;
>  		} else
>  			dev_priv->display.update_wm = pineview_update_wm;
> +		dev_priv->display.init_clock_gating = gen3_init_clock_gating;
>  	} else if (IS_G4X(dev)) {
>  		dev_priv->display.update_wm = g4x_update_wm;
>  		dev_priv->display.init_clock_gating = g4x_init_clock_gating;
> 

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
