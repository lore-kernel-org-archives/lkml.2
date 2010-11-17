Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab0KQKUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:20:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:27919 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0KQKUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:20:18 -0500
Message-Id: <b9dded$h40vqf@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,210,1288594800"; 
   d="scan'208";a="574652239"
Date: Wed, 17 Nov 2010 10:20:09 +0000
To: Tino Keitel <tino.keitel@tikei.de>, linux-kernel@vger.kernel.org
Subject: Re: DVI/EDID broken with Intel i945 graphics and 2.6.37-rc2
In-Reply-To: <20101116184914.GA15794@mac.home>
References: <20101116184914.GA15794@mac.home>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 19:49:14 +0100, Tino Keitel <tino.keitel@tikei.de> wrote:
> Hi,
> 
> 2.6.37-rc2 doesn't seem to detect the LCD connected via DVI on my Mac
> mini Core2 Duo with i945 graphics:

Hmm, sounds like fallout from detection of the VGA connection on the shared
GPIO wire.

Does this help?

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo
index de158b7..ec32ceb 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1327,11 +1327,8 @@ intel_analog_is_connected(struct drm_device *dev)
        if (!analog_connector)
                return false;
 
-       if (analog_connector->funcs->detect(analog_connector, false) ==
-                       connector_status_disconnected)
-               return false;
-
-       return true;
+       return analog_connector->funcs->detect(analog_connector, false) ==
+               connector_status_connected;
 }
 
An alternative is to force detection, ie change the detect(analog, false)
to true.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
