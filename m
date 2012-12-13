Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2LMUoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 15:44:21 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63148 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2LMUoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 15:44:20 -0500
Date: Thu, 13 Dec 2012 21:45:39 +0100
From: Laurent Navet <laurent.navet@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: bskeggs@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, airlied@linux.ie,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers: nouveau: Bool tests don't need comparison
Message-ID: <20121213204538.GA7031@gmail.com>
References: <1355320451-23292-1-git-send-email-laurent.navet@gmail.com>
 <20121213081657.GV6568@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213081657.GV6568@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bool initializations should use true and false.  Bool tests don't need
comparisons.  Based on contributions from Joe Perches, Rusty Russell
and Bruce W Allan.
The semantic patch that makes this output is available
in scripts/coccinelle/misc/boolinit.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/gpu/drm/nouveau/core/subdev/timer/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/timer/base.c
b/drivers/gpu/drm/nouveau/core/subdev/timer/base.c
index 5d417cc..de6d6b7 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/timer/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/timer/base.c
@@ -72,7 +72,7 @@ nouveau_timer_wait_cb(void *obj, u64 nsec, bool
(*func)(void *), void *data)
 
        time0 = ptimer->read(ptimer);
        do {
-               if (func(data) == true)
+               if (func(data))
                        return true;
        } while (ptimer->read(ptimer) - time0 < nsec);
 
-- 
1.7.10.4
