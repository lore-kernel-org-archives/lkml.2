Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab0JLV23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:28:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52226 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab0JLV22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:28:28 -0400
Date: Tue, 12 Oct 2010 21:51:19 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1010122147180.27797@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I was going to leave these for stable, but really they should go in now.

The unmappable VRAM fixes a problem on evergreen cards in 2.6.36, we end 
up giving out memory past what the CPU can see and we get SIGBUS in 
userspace, this is because we don't have support for GPU to move memory 
around on evergreen until patches queued for 2.6.37. This patch just 
limits the VRAM when we don't have any in-kernel gpu copy code.

There are two other minor evergreen fixes, and two not so useful output 
removed patches.

Dave.


The following changes since commit 85a331881dd52a93e7d4c57bcaf5486cc8718465:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2010-10-09 12:06:26 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (3):
      drm/radeon/kms: leave certain CP int bits enabled
      drm/radeon/kms: make TV/DFP table info less verbose
      drm/radeon/kms: fix bad cast/shift in evergreen.c

Jean Delvare (1):
      drm/radeon/kms: Silent spurious error message

Jerome Glisse (1):
      drm/radeon/kms: avoid corner case issue with unmappable vram V2

 drivers/gpu/drm/radeon/evergreen.c       |    5 +++--
 drivers/gpu/drm/radeon/r100.c            |    3 +++
 drivers/gpu/drm/radeon/r600.c            |    4 +++-
 drivers/gpu/drm/radeon/r600_blit_kms.c   |    2 ++
 drivers/gpu/drm/radeon/radeon.h          |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c |   18 +++++++++---------
 drivers/gpu/drm/radeon/radeon_combios.c  |   26 +++++++++++++-------------
 drivers/gpu/drm/radeon/radeon_object.c   |    2 +-
 drivers/gpu/drm/radeon/radeon_object.h   |    5 +----
 drivers/gpu/drm/radeon/rs600.c           |    1 +
 drivers/gpu/drm/radeon/rs690.c           |    1 +
 drivers/gpu/drm/radeon/rv770.c           |    2 ++
 12 files changed, 40 insertions(+), 30 deletions(-)
