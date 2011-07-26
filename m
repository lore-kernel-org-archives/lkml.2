Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1GZQgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:36:42 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:56061 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753684Ab1GZQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:36:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=QFi9RsjTuUHDmNs3galyRaPQ3jn+0HBt1gO9g0iw3d/CiIQQ2fqqg/sYdTTl0+mr7uVtk93Skth04uzJqQqxlTC3pbgFfIC9Galw9k5+Evy3sFAQfmMtbaCsFDHndbPr;
Date: Tue, 26 Jul 2011 09:36:24 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 1/5] drm/i915: Use dp_detect_common in
 hotplug helper function
Message-ID: <20110726093624.2d067e1b@jbarnes-desktop>
In-Reply-To: <1311662194-4050-2-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
	<1311662194-4050-2-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011 23:36:30 -0700
Keith Packard <keithp@keithp.com> wrote:

> This uses the common dpcd reading routine, i915_dp_detect_common,
> instead of open-coding a call to intel_dp_aux_native_read. Besides
> reducing duplicated code, this also gains the read retries which
> may be necessary when a cable is first plugged back in and the link
> needs to be retrained.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |   39 +++++++++++++++++++--------------------
>  1 files changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index dcc7ae6..45db810 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -1567,6 +1567,20 @@ intel_dp_link_down(struct intel_dp *intel_dp)
>  	POSTING_READ(intel_dp->output_reg);
>  }
>  
> +static enum drm_connector_status
> +i915_dp_detect_common(struct intel_dp *intel_dp)

Maybe you can fix the prefix of this function while you're at it since
it's not i915 or even i9xx specific?

-- 
Jesse Barnes, Intel Open Source Technology Center
