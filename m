Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0D1D6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 23:58:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37038 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab0D1D60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 23:58:26 -0400
Date: Wed, 28 Apr 2010 13:58:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>,
       Tormod Volden <debian.tormod@gmail.com>,
       Alex Deucher <alexdeucher@gmail.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20100428135823.b4b70ca3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/r300.c between commit
94f7bf647315472c80b8368c849739038e5620a3 ("drm/radeon: 9800 SE has only
one quadpipe") from Linus' tree and commit
90aca4d2740255bd130ea71a91530b9920c70abe ("drm/radeon/kms: simplify &
improve GPU reset V2") from the drm tree.

Just context changes. I fixed it up (see below) and can carry the fix for
a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/radeon/r300.c
index eaf1f6b,bb005bf..0000000
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@@ -323,9 -328,9 +328,8 @@@ void r300_gpu_init(struct radeon_devic
  {
  	uint32_t gb_tile_config, tmp;
  
- 	r100_hdp_reset(rdev);
 -	/* FIXME: rv380 one pipes ? */
  	if ((rdev->family == CHIP_R300 && rdev->pdev->device != 0x4144) ||
 -	    (rdev->family == CHIP_R350)) {
 +	    (rdev->family == CHIP_R350 && rdev->pdev->device != 0x4148)) {
  		/* r300,r350 */
  		rdev->num_gb_pipes = 2;
  	} else {
