Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab2F2E43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 00:56:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7714 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2F2E42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 00:56:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 28 Jun 2012 21:56:27 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/2] More precise error reporting for of_get_named_gpio
Date: Fri, 29 Jun 2012 13:57:57 +0900
Message-ID: <1340945879-11712-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_named_gpio is a very convenient way to get a GPIO from a device
tree. However it makes no difference between an invalid property or
the absence of it and returns -EINVAL in both cases.

Sometimes a GPIO property can be optional, and so far we need to use
a separate call to e.g. of_get_property. These two patches make it
possible to differenciate both cases by having
of_parse_phandle_with_args return -ENOENT instead of -EINVAL if the
requested property does not exist, and of_get_named_gpio_flags
propage the return value of of_parse_phandle_with_args instead of
invariably returning -EINVAL/

Alexandre Courbot (2):
  of: return -ENOENT when no property
  gpio: propagate of_parse_phandle_with_args errors

 drivers/gpio/gpiolib-of.c | 2 +-
 drivers/of/base.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.11.1

