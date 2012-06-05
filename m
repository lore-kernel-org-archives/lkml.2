Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2FEQQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:16:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3427 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab2FEQQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:16:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6733"; a="195619875"
Message-ID: <4FCE30D6.7060102@codeaurora.org>
Date: Tue, 05 Jun 2012 09:16:22 -0700
From: David Collins <collinsd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Rajendra Nayak <rnayak@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Supporting non-device tree consumers with device tree regulator drivers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was wondering if a mechanism currently exists which allows regulator
devices which have probed via device tree to support regulator consumer
drivers which have probed via a board file (and thus have no associated
device tree device_node).  It seems that the current setup is such that if
a regulator driver probes via a board file device, then it will be passed
a struct regulator_init_data pointer containing a consumer_supplies list
via platform_data.  This allows the regulator driver to support consumers
that are probed via device tree nodes or via a board file.  However, if a
regulator driver probes via a device tree node, then it will only be
accessible to consumer drivers which have nodes in device tree and which
specify their own foo-supply=<&regulator_phandle>; mappings.  When a
regulator device is probed via device tree, the consumer_supplies pointer
is left null by of_get_regulator_init_data().  This seems to make
regulators probed via device tree nodes inaccessible to non-device tree
consumers.

In the long term, this problem should go away of its own accord.  However,
in the short term, many systems are converting over to using device tree.
 Therefore, we are left with a situation currently where some regulator
consumer drivers are being probed via device tree and some are being
probed via board file devices within a single platform.  If the regulator
driver supporting the consumer drivers is converted to use device tree and
probed via device tree, then the non-device tree consumer drivers will not
be able to make use of the regulator devices.

Would it be possible to add a new binding that is handled inside of
of_get_regulator_init_data() or of_get_regulation_constraints() that
provides a means to directly specify regulator_init_data.consumer_supplies
entries?  Is there some other mechanism that could be used instead to
handle the mapping?

One potentially binding could be:
regulator-consumer-supplies = "supply_name1", "device_name1",
"supply_name2", "device_name2", ...

Thank you,
David Collins

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
