Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2BQO6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:58:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6283 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2BQO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:58:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 17 Feb 2012 06:58:46 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V2 1/3] Documentation: gpio: Add details of open-drain/source configuration
Date: Fri, 17 Feb 2012 20:26:20 +0530
Message-Id: <1329490582-22107-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1329490582-22107-1-git-send-email-ldewangan@nvidia.com>
References: <1329490582-22107-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding details of open drain(open collector) and open source
(open emitter) configuration of the gpio so that client can
set the pin as open drain at the time of gpio request.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 Documentation/gpio.txt |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 792faa3..f783e7f 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -302,6 +302,8 @@ where 'flags' is currently defined to specify the following properties:
 
 	* GPIOF_INIT_LOW	- as output, set initial level to LOW
 	* GPIOF_INIT_HIGH	- as output, set initial level to HIGH
+	* GPIOF_OPEN_DRAIN	- gpio pin is open drain type.
+	* GPIOF_OPEN_SOURCE	- gpio pin is open source type.
 
 since GPIOF_INIT_* are only valid when configured as output, so group valid
 combinations as:
@@ -310,8 +312,19 @@ combinations as:
 	* GPIOF_OUT_INIT_LOW	- configured as output, initial level LOW
 	* GPIOF_OUT_INIT_HIGH	- configured as output, initial level HIGH
 
-In the future, these flags can be extended to support more properties such
-as open-drain status.
+When setting the flag as GPIOF_OPEN_DRAIN then it will assume that pins is
+open drain type. Such pins will not be driven to 1 in output mode. It is
+require to connect pull-up on such pins. By enabling this flag, gpio lib will
+make the direction to input when it is asked to set value of 1 in output mode
+to make the pin HIGH. The pin is make to LOW by driving value 0 in output mode.
+
+When setting the flag as GPIOF_OPEN_SOURCE then it will assume that pins is
+open source type. Such pins will not be driven to 0 in output mode. It is
+require to connect pull-down on such pin. By enabling this flag, gpio lib will
+make the direction to input when it is asked to set value of 0 in output mode
+to make the pin LOW. The pin is make to HIGH by driving value 1 in output mode.
+
+In the future, these flags can be extended to support more properties.
 
 Further more, to ease the claim/release of multiple GPIOs, 'struct gpio' is
 introduced to encapsulate all three fields as:
-- 
1.7.1.1

