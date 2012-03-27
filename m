Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2C0TSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:18:18 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:64400 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755278Ab2C0TSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:18:16 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 10/13 v4] drm/i915/intel_i2c: always wait for IDLE before clearing NAK
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1332873382-29373-11-git-send-email-djkurtz@chromium.org>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org> <1332873382-29373-11-git-send-email-djkurtz@chromium.org>
Date: Tue, 27 Mar 2012 20:17:59 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332875892_117312@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 02:36:19 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> The GMBUS controller can report a NAK condition while a transaction is
> still active. If the driver is fast enough, and the bus is slow enough,
> the driver may clear the NAK condition while the controller is still
> busy, resulting in a confused GMBUS controller.  This will leave the
> controller in a bad state such that the next transaction may fail.
> 
> Also, return -ENXIO if a device NAKs a transaction.
> 
> Note: this patch also refactors gmbus_xfer to remove the "done" label.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

Thanks for clarifying the appropriate return codes.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
