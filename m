Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2BWUTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:19:21 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:63646 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756748Ab2BWUTU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:19:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of just.for.lkml@googlemail.com designates 10.60.26.166 as permitted sender) smtp.mail=just.for.lkml@googlemail.com; dkim=pass header.i=just.for.lkml@googlemail.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1202221952430.18534@skynet.skynet.ie>
References: <alpine.DEB.2.00.1202221952430.18534@skynet.skynet.ie>
Date: Thu, 23 Feb 2012 21:19:20 +0100
Message-ID: <CAPVoSvSvQv14dM6EWTi3YxUtxNWB8+kypDHSwkYTiWpBxL2eug@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 8:56 PM, Dave Airlie <airlied@linux.ie> wrote:
> Eugeni Dodonov (4):
>      drm/i915: gen7: implement rczunit workaround
>      drm/i915: gen7: Implement an L3 caching workaround.
>      drm/i915: gen7: work around a system hang on IVB
>      drm/i915: do not enable RC6p on Sandy Bridge

That last patch about RC6p looks wrong.

It does:
 GEN6_RC_CTL_RC6_ENABLE |
			(IS_GEN7(dev_priv->dev)) ? GEN6_RC_CTL_RC6p_ENABLE : 0;
But I think this was meant:
 GEN6_RC_CTL_RC6_ENABLE |
			((IS_GEN7(dev_priv->dev)) ? GEN6_RC_CTL_RC6p_ENABLE : 0);

Or did I get the operator precedence wrong?

HTH

Torsten
