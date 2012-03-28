Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab2C1StM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:49:12 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:53694 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932358Ab2C1StL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:49:11 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 4/7 v6] drm/i915/intel_i2c: use WAIT cycle, not STOP
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1332959199-32161-5-git-send-email-djkurtz@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org> <1332959199-32161-5-git-send-email-djkurtz@chromium.org>
Date: Wed, 28 Mar 2012 19:48:51 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332960542_131144@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 02:26:36 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> The i915 is only able to generate a STOP cycle (i.e. finalize an i2c
> transaction) during a DATA or WAIT phase.  In other words, the
> controller rejects a STOP requested as part of the first transaction in a
> sequence.

The original docs have "this can only cause a STOP to be generated if a
GMBUS cycle is generated, the GMBUS is currently in a data phase, or it
is in a WAIT phase."

So from that it seems STOP | INDEX? | WAIT is always a valid
combination and is explicitly listed in the register set.

I defer to actual testing though ;)
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
