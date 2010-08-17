Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab0HQSGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:06:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3578 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab0HQSGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:06:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6077"; a="51203944"
Message-ID: <4C6ACF92.7050506@codeaurora.org>
Date: Tue, 17 Aug 2010 11:06:10 -0700
From: Bobby Crabtree <bobbyc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: regulator voltage aggregation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking to upstream a new feature in which the regulator core
aggregates voltage requests from multiple consumers and applies the best
fitting voltage (e.g. max voltage) to a shared supply. The core would
recompute the best fitting voltage when a consumer requests a voltage
change or requests to enable/disable the regulator (similar logic to
DRMS).

The reason we need this feature is for power savings. It would allow two
or more consumers to "vote" on a voltage that's lower than the normal
operating voltage.

I've got a couple implementations in mind.

1. Introduce a new API:

int regulator_set_optimum_voltage(struct regulator *regulator,
                int min_uV, int max_uV);

2. Add a flag to the regulation_constraints structure and reuse the
existing regulator_set_voltage API.

struct regulation_constraints {
        ...
        unsigned aggregate_uV:1;
        ...
};

Does this sound like a reasonable feature? And if so, are there any
preferences as to how the feature is implemented and exposed?

Bobby Crabtree

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
