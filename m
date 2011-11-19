Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1KSJZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 04:25:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63332 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab1KSJZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 04:25:51 -0500
MIME-Version: 1.0
In-Reply-To: <1321684889-18691-1-git-send-email-keithp@keithp.com>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
From: Eugeni Dodonov <eugeni@dodonov.net>
Date: Sat, 19 Nov 2011 07:25:09 -0200
X-Google-Sender-Auth: _pVEeKZT3p1fi6KImHP89O-WMVE
Message-ID: <CAC7LmnuWLA1LFQa-Vg4StOryo_wd1KjwaQ7m+Yb8Nhek7f=Qjw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: By default, enable RC6 on IVB and SNB when reasonable
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 04:41, Keith Packard <keithp@keithp.com> wrote:
>
> +static bool intel_enable_rc6(struct drm_device *dev)
> +{
> +       if (i915_enable_rc6 >= 0)
> +               return i915_enable_rc6;
> +       if (INTEL_INFO(dev)->gen >= 7)
> +               return 1;
> +#ifdef CONFIG_INTEL_IOMMU
> +       /*
> +        * Only enable RC6 if all dma remapping is disabled, or if
> +        * there's no iommu present in the machine.
> +        */
> +       if (INTEL_INFO(dev)->gen == 6)
> +               return no_iommu || dmar_disabled;
> +#endif
> +       return 0;
> +}

Just one question I caught on 2nd read. Shouldn't we have #else within
this #ifdef block, to return 1? Otherwise, if CONFIG_INTEL_IOMMU is
not defined, we'll always disable rc6.

Or we just always intend to disable rc6 in case CONFIG_INTEL_IOMMU is not there?

--
Eugeni Dodonov
