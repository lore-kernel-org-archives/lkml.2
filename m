Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab2C2JwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:52:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39587 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2C2JwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:52:14 -0400
Message-ID: <4F7430C7.6060505@linaro.org>
Date: Thu, 29 Mar 2012 10:52:07 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: broonie@opensource.wolfsonmicro.com
CC: Grant Likely <grant.likely@secretlab.ca>, lrg@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Board breakage due to upstream patch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Your patch "regulator: Support driver probe deferral" (below) prevents my Snowball Development Board from booting.

What's the correct thing to do?

---------------------------------------------------------------------

Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Sun Mar 11 13:07:56 2012 +0000

    regulator: Support driver probe deferral
    
    If we fail to locate a requested regulator return -EPROBE_DEFER. If drivers
    pass this error code through to their caller (which they really should)
    then this will ensure that the probe is retried later when further devices
    become available.  In the unusual case where a driver doesn't want this
    it can override the default behaviour.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Acked-by: Grant Likely <grant.likely@secretlab.ca>
    Acked-by: Liam Girdwood <lrg@ti.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e9a83f8..fcde037 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1210,7 +1210,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 {
        struct regulator_dev *rdev;
        struct regulator_map *map;
-       struct regulator *regulator = ERR_PTR(-ENODEV);
+       struct regulator *regulator = ERR_PTR(-EPROBE_DEFER);
        const char *devname = NULL;
        int ret;
 
@@ -2834,7 +2834,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 
                if (!r) {
                        dev_err(dev, "Failed to find supply %s\n", supply);
-                       ret = -ENODEV;
+                       ret = -EPROBE_DEFER;
                        goto scrub;
                }

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515 
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
