Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163152Ab1FAI23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:28:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162224Ab1FAI2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:28:24 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:21 2011
Message-Id: <20110601081221.256514796@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:00 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [150/165] drm/radeon/kms: fix incorrect comparison in cayman setup
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 code.
Content-Length: 1043
Lines: 27

From: Dave Airlie <airlied@redhat.com>

commit c289cff10a265ec4afe4396425297ff979a840b5 upstream.

This was leading to a bogus value being programmed to the backend
routing register.

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/ni.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -417,7 +417,7 @@ static u32 cayman_get_tile_pipe_to_backe
 		num_shader_engines = 1;
 	if (num_shader_engines > rdev->config.cayman.max_shader_engines)
 		num_shader_engines = rdev->config.cayman.max_shader_engines;
-	if (num_backends_per_asic > num_shader_engines)
+	if (num_backends_per_asic < num_shader_engines)
 		num_backends_per_asic = num_shader_engines;
 	if (num_backends_per_asic > (rdev->config.cayman.max_backends_per_se * num_shader_engines))
 		num_backends_per_asic = rdev->config.cayman.max_backends_per_se * num_shader_engines;


