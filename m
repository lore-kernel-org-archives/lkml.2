Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1DEVih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:38:37 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:40637 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494Ab1DEViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:38:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ldutIKp4LLPEZW5VRbGwL1RVL8VUnII5yapUiBzzchDbihPQ8mrwan4oJenCi0lkOC
         5adPhgUYbfb2z2iQcUbvn1v8eLKy2CEthIwJasgE7u2wwOpdBXvxUepdOnnE8cwjHfs3
         nD9ZDQTP2dfBvBgk9OYsEL/EIGs+4Un83cXk8=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: davinci-linux-open-source@linux.davincidsp.com, linux-i2c@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        Brad Griffis <bgriffis@ti.com>, Jon Povey <jon.povey@racelogic.co.uk>,
        Philby John <pjohn@in.mvista.com>, Sekhar Nori <nsekhar@ti.com>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 6/6] da8xx: enable the use of the ICPFUNC in i2c-davinci
Date: Tue,  5 Apr 2011 17:38:09 -0400
Message-Id: <f1ff3f2888725a1e03541e0be5c0880f0591aea2.1302031487.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1302031487.git.bengardiner@nanometrics.ca>
References: <cover.1302031487.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both the da850 and da830 have an I2C controller which has the ICPFUNC
registers. Indicate this for all da830 and da850 boards by setting the
has_pfunc flag true in the da8xx utility setup routine for registering the
I2C controller

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Ben Dooks <ben-linux@fluff.org>

---
 arch/arm/mach-davinci/devices-da8xx.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index beda8a4..da01558 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -324,6 +324,12 @@ int __init da8xx_register_i2c(int instance,
 	else
 		return -EINVAL;
 
+	/*
+	 * Both the DA850 and DA830 have an I2C controller which has the
+	 * ICPFUNC et. al. registers
+	 */
+	pdata->has_pfunc = 1;
+
 	pdev->dev.platform_data = pdata;
 	return platform_device_register(pdev);
 }
-- 
1.7.1

