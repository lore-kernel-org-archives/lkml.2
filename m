Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1EYTI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:08:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45362 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1EYTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=NqC4NuUW9JmK0KLxJ7jJMAUVyPNCJR9CokP3PJFM391yXY0uUVZKpYImOfWJZqBoFk
         Iz4/xW26xCtpisqNKT0Yp//PU5Pn5sxDdTFGMTgTX17cz+lfL2Wp0xx1c4Xm2WkwzdCD
         iqme9o6X05FbATk4bBtKnGn/tYKA1sdkkpPRE=
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 25 May 2011 19:08:06 +0000
Message-ID: <BANLkTimR2ggkjDiB9fZDuHJOuFX1Pb=rMw@mail.gmail.com>
Subject: [PATCH] cs5535 mfgpt - fix wrong if condition
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Gmeiner <christian.gmeiner@gmail.com>

This patch fixes the wrong if condition for the check if the
requested timer is available.

The bitmap avail is used to store if a timer is used already.
test_bit() is used to check if the requested timer is
available. If a bit in the avail bitmap is set it means that the
timer is available.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 drivers/misc/cs5535-mfgpt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index e01e08c..bc685bf 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -174,7 +174,7 @@ struct cs5535_mfgpt_timer
*cs5535_mfgpt_alloc_timer(int timer_nr, int domain)
                timer_nr = t < max ? (int) t : -1;
        } else {
                /* check if the requested timer's available */
-               if (test_bit(timer_nr, mfgpt->avail))
+               if (!test_bit(timer_nr, mfgpt->avail))
                        timer_nr = -1;
        }

-- 
1.7.5.rc3

--
Christian Gmeiner, MSc
