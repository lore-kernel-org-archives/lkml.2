Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab1JSIya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:54:30 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59932 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab1JSIy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:54:29 -0400
Date: Wed, 19 Oct 2011 09:54:31 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1110190951370.5742@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

one quite urgent fixes for AMD Llano APU users, one earlier patch 
uncovered a bug in the atom parsing code that resulted in semi-random 
memory corruption when executing load detection tables. I spent a few days 
scratching my head and Alex figured it out once I got enough debug logs. 
We've also added bounds checking so it can't happen again.

The other fixes are radeon modesetting fixes and a ttm fix.

Dave.


The following changes since commit 899e3ee404961a90b828ad527573aaaac39f0ab1:

  Linux 3.1-rc10 (2011-10-17 21:06:23 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~/linux drm-fixes

Alex Deucher (4):
      drm/radeon/kms/DCE4.1: fix dig encoder to transmitter mapping
      drm/radeon/kms/DCE4.1: ss is not supported on the internal pplls
      drm/radeon/kms/DCE4.1: fix Select_CrtcSource EncodeMode setting for DP bridges (v2)
      drm/radeon/kms/atom: fix handling of FB scratch indices

Thomas Hellstrom (1):
      ttm: Fix error-path using an uninitialized value

 drivers/gpu/drm/radeon/atom.c            |   15 +++++++++++++--
 drivers/gpu/drm/radeon/atom.h            |    1 +
 drivers/gpu/drm/radeon/atombios_crtc.c   |    2 +-
 drivers/gpu/drm/radeon/radeon_encoders.c |   25 ++++++++++++++++++++-----
 drivers/gpu/drm/ttm/ttm_bo_util.c        |    2 +-
 5 files changed, 36 insertions(+), 9 deletions(-)
