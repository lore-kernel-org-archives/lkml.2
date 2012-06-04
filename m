Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175Ab2FDKg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:36:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35384 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab2FDKg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:36:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6731"; a="195054640"
Message-ID: <69926c6ce4b1e004069662fb13287e9b.squirrel@www.codeaurora.org>
In-Reply-To: <20120604102747.GC7538@opensource.wolfsonmicro.com>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
    <20120601001617.GA16311@plastictigers.com>
    <74993ac9d11db0db7080c0864daef397.squirrel@www.codeaurora.org>
    <20120604102747.GC7538@opensource.wolfsonmicro.com>
Date: Mon, 4 Jun 2012 03:36:55 -0700 (PDT)
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
From: "Sagar Dharia" <sdharia@codeaurora.org>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Sagar Dharia" <sdharia@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, kheitke@codeaurora.org, gclemson@audience.com,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rob@landley.net, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        ohad@wizery.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rusty@rustcorp.com.au, joerg.roedel@amd.com, trenn@suse.de,
        ak@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Reply-To: sdharia@codeaurora.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> While taking care of the comments for RFC, I have introduced a
>> completion
>> that will be signalled when LA is given to the device. The driver can
>> wait
>> on that completion (wait_enum) instead of polling.
>
> This would mean that the thread the probe is happening in will be
> blocked until the LA is assigned.  That sounds like it might cause
> problems, either slowing things down or worst case causing a deadlock.
>
I would expect that the slim_device's driver will only power-on the device
during probe (and use wait_for_completion during 1st transfer to get LA).
Typically transfers are not done as part of probe. Even if transfers need
to be done as part of probe, I expect wait_for_completion (with timeout to
avoid potential HW problems causing linux probe to wait forever) will be
better than polling for get_logical_addr.


Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

