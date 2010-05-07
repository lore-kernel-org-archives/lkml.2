Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0EGIkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:40:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38170 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab0EGIkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=tSufo1Pskl7JbSHC3x5YOSuFHx2UWlco3NM3Fghm3VxH7RMDdHIBHTWbOT+P/266d0
         f99PYFCOO6M9AELlL9IUEWofxPzvXXPxrGX6fGA5D7rvhIwp/u02z0ojBcClcWpkWc+y
         ExWb2AE3ZFgfRqj48j834hLM2kLbNkWcZvpbE=
Date: Fri, 7 May 2010 10:40:09 +0200
From: Dan Carpenter <error27@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>, Zhao Yakui <yakui.zhao@intel.com>,
       Ma Ling <ling.ma@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
       Keith Packard <keithp@keithp.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] i915/intel_sdvo: remove unneeded null check
Message-ID: <20100507084009.GZ27064@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
	Zhao Yakui <yakui.zhao@intel.com>, Ma Ling <ling.ma@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Keith Packard <keithp@keithp.com>, dri-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "connector" variable is used as the cursor in a
list_for_each_entry() and it's always non-null so we don't need to check
it.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 42ceb15..179d146 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1479,7 +1479,7 @@ intel_find_analog_connector(struct drm_device *dev)
 		intel_encoder = enc_to_intel_encoder(encoder);
 		if (intel_encoder->type == INTEL_OUTPUT_ANALOG) {
 			list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-				if (connector && encoder == intel_attached_encoder(connector))
+				if (encoder == intel_attached_encoder(connector))
 					return connector;
 			}
 		}
