Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297Ab0GTPIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:08:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559Ab0GTPIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:08:49 -0400
Date: Tue, 20 Jul 2010 17:08:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>, Ma Ling <ling.ma@intel.com>,
        Ian Romanick <ian.d.romanick@intel.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/16] trivial: use ARRAY_SIZE
In-Reply-To: <1277726097-24534-1-git-send-email-segooon@gmail.com>
Message-ID: <alpine.LNX.2.00.1007201708300.4741@pobox.suse.cz>
References: <1277726097-24534-1-git-send-email-segooon@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Kulikov Vasiliy wrote:

> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/gpu/drm/i915/intel_sdvo.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
> index 76993ac..03c231b 100644
> --- a/drivers/gpu/drm/i915/intel_sdvo.c
> +++ b/drivers/gpu/drm/i915/intel_sdvo.c
> @@ -392,13 +392,13 @@ static void intel_sdvo_debug_write(struct intel_encoder *intel_encoder, u8 cmd,
>  		DRM_LOG_KMS("%02X ", ((u8 *)args)[i]);
>  	for (; i < 8; i++)
>  		DRM_LOG_KMS("   ");
> -	for (i = 0; i < sizeof(sdvo_cmd_names) / sizeof(sdvo_cmd_names[0]); i++) {
> +	for (i = 0; i < ARRAY_SIZE(sdvo_cmd_names); i++) {
>  		if (cmd == sdvo_cmd_names[i].cmd) {
>  			DRM_LOG_KMS("(%s)", sdvo_cmd_names[i].name);
>  			break;
>  		}
>  	}
> -	if (i == sizeof(sdvo_cmd_names)/ sizeof(sdvo_cmd_names[0]))
> +	if (i == ARRAY_SIZE(sdvo_cmd_names))
>  		DRM_LOG_KMS("(%02X)", cmd);
>  	DRM_LOG_KMS("\n");
>  }

Applied to trivial queue, as linux-next as of today doesn't carry this 
patch.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
