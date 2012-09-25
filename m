Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2IYQKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:10:00 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57612 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab2IYQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:09:59 -0400
MIME-Version: 1.0
In-Reply-To: <1348584252-22778-2-git-send-email-Dmitrii.Cherkasov@amd.com>
References: <1348584252-22778-1-git-send-email-Dmitrii.Cherkasov@amd.com>
	<1348584252-22778-2-git-send-email-Dmitrii.Cherkasov@amd.com>
Date: Tue, 25 Sep 2012 20:09:59 +0400
Message-ID: <CAN0j1dThyR1YF-JvT+xZ-QO2QxwB-z_L0tvx5ftZKjZ6oZ-JGg@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/radeon: implement dynamic PTs allocation via SA
From: Dmitry Cherkassov <dcherkassov@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        Dmitry Cherkasov <Dmitrii.Cherkasov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've found introduced  error in radeon_vm_free_pt, so will fix in next
version of this patch.

This one:

--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -505,15 +505,6 @@ static void radeon_vm_free_pt(struct radeon_device *rdev,
        int driver_table_entries = (rdev->vm_manager.max_pfn >>
                                    RADEON_VM_BLOCK_SIZE);

-                       if (vm->vm_pts->bo)
+                      if (vm->vm_pts[i].bo)


-- 
With best regards,
Dmitry
