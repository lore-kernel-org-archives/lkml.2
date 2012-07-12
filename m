Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665Ab2GLKY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:24:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15750 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab2GLKYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:24:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 12 Jul 2012 03:23:45 -0700
Subject: How to use the generic thermal sysfs.
From: Wei Ni <wni@nvidia.com>
To: <rui.zhang@intel.com>, <len.brown@intel.com>, <akpm@linux-foundation.org>,
        <khali@linux-fr.org>, <joe@perches.com>, <durgadoss.r@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@ger.kernel.org>,
        <acourbot@nvidia.com>
Date: Thu, 12 Jul 2012 18:22:53 +0800
Message-ID: <1342088573.27605.101.camel@tegra-chromium-2>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all
I'm working on the tegra thermal throttling upstream issue.
The tegra30 board use the nct1008 as the thermal sensor, and the lm90 is
the sensor driver. We want to use the generic thermal sysfs.
 
My question is where should we register the thermal zone device? We may
have two place to do it:
1. register it in the sensor driver, such as lm90.c
In this way, the sensor driver doesn't need to export any APIs, such as
get_temp.
2. register in my tegra thermal framework.
In this way, the sensor driver need to export some APIs, which are used
to register the ops and do any other things.

How should I do it?

And in current codes, there have the event notification, in the form of
a netlink event. But it's difficult to be used in the kernel, it's
normally for the communication with user-space. How about to add a
notify call chain for it? So when the sensor has irq alert, it can send
a notify to my thermal framework in kernel.

Do anyone has suggestions?

Thanks.
Wei.

---
nvpublic

