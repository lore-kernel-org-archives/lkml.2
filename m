Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1KDRj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 13:39:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47954 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab1KDRjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 13:39:55 -0400
Date: Fri, 4 Nov 2011 13:44:01 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Andrew Watts <akwatts@ymail.com>
Cc: Tejun Heo <tj@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111104174401.GB2015@homer.localdomain>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
 <20111102160208.GA6657@zeus>
 <20111102163109.GA29430@core.coreip.homeip.net>
 <20111103155956.GG4417@google.com>
 <20111103184559.GA3295@zeus>
 <20111103213959.GP4417@google.com>
 <20111104134347.GA2480@zeus>
 <20111104161431.GZ4417@google.com>
 <20111104173441.GA2157@zeus>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20111104173441.GA2157@zeus>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 04, 2011 at 12:34:58PM -0500, Andrew Watts wrote:
> On Fri, Nov 04, 2011 at 09:14:31AM -0700, Tejun Heo wrote:
> > Andrew, can you please kill the X server after the hang and see
> > whether that brings the system back?  I think sshd should still work
> > and if not you can write a script to kill the X server after 30secs
> > after resume (and kill that script if resume succeeds).
> 
> Hi Tejun & Jerome.
> 
> Tejun: My script killed X after a small wait from a bad resume. I am returned 
> to the funcioning calling console. I can then re-start X and all subsystems
> seem to working fine.
> 
> Jerome: I posted a post-bad-resume dmesg snippet with a GPU lockup warning
> and trace here:
> 
>    http://article.gmane.org/gmane.linux.kernel/1210057
> 
> Did you need to see more?
> 
> Thanks.
> 
> ~ Andy
> 

Attached patch might hide the issue.

Cheers,
Jerome

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-drm-radeon-kms-make-sure-GPU-is-idle-and-working-at-.patch"

>From a13af3d0bff9e093160da63f22c6b44e436aa570 Mon Sep 17 00:00:00 2001
From: Jerome Glisse <jglisse@redhat.com>
Date: Fri, 4 Nov 2011 13:41:37 -0400
Subject: [PATCH] drm/radeon/kms: make sure GPU is idle and working at end of
 resume

This might hide some GPU lockup issue deadlock on resume.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index c33bc91..1158e55 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -947,6 +947,7 @@ int radeon_resume_kms(struct drm_device *dev)
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
 	}
+	radeon_fence_wait_last(rdev);
 	return 0;
 }
 
-- 
1.7.6.4


--X1bOJ3K7DJ5YkBrT--
