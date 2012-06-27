Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2F0Ifp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:35:45 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:30377 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199Ab2F0Ifl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:35:41 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915/sprite: Fix mem leak in intel_plane_init()
To: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
In-Reply-To: <alpine.LNX.2.00.1206270053570.3759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206270053570.3759@swampdragon.chaosbits.net>
Date: Wed, 27 Jun 2012 09:34:43 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1340786125_85379@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 00:55:37 +0200 (CEST), Jesper Juhl <jj@chaosbits.net> wrote:
> If we ever hit the default case in the switch statement we'll return
> from the function without freeing the memory we just allocated to
> 'intel_plane' (but that has not been used).
> 
> This patch gets rid of the leak by freeing the memory just before we
> return.

Heh, I was more worried about the real leak of the planes on module
unload.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
