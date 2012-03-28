Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab2C1Slm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:41:42 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:52820 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758273Ab2C1Sll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:41:41 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 2/7 v6] drm/i915/intel_i2c: use double-buffered writes
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1332959199-32161-3-git-send-email-djkurtz@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org> <1332959199-32161-3-git-send-email-djkurtz@chromium.org>
Date: Wed, 28 Mar 2012 19:41:21 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332960093_131068@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 02:26:34 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> The GMBUS controller GMBUS3 register is double-buffered.  Take advantage
> of this  by writing two 4-byte words before the first wait for HW_RDY.
> This helps keep the GMBUS controller from becoming idle during long writes.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

"For byte counts that are greater than four bytes, this register will be
written with subsequent data only after the HW_RDY status bit is set"

Hmm, I had interpretted that as should only be. But if you take into
account that the register is indeed double-buffered, it does make sense
that the hardware itself is only updated after the HW_RDY signal.
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
