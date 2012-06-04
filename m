Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab2FDKVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:21:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64238 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab2FDKVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:21:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6731"; a="197375485"
Message-ID: <74993ac9d11db0db7080c0864daef397.squirrel@www.codeaurora.org>
In-Reply-To: <20120601001617.GA16311@plastictigers.com>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
    <20120601001617.GA16311@plastictigers.com>
Date: Mon, 4 Jun 2012 03:21:06 -0700 (PDT)
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
From: "Sagar Dharia" <sdharia@codeaurora.org>
To: "Sagar Dharia" <sdharia@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, kheitke@codeaurora.org, gclemson@audience.com,
        broonie@opensource.wolfsonmicro.com, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rob@landley.net,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, ohad@wizery.com,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
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

> These are initial comments. A full review of the patch will take some
> time. While I am posting this email, this is the result of work both
> by myself, and my colleague Greg Clemson (cc'ed).
>
Thank you Marc and Greg for taking time to review this.

> The enumeration slim_ch_proto is incorrect. It declares 2 transport
> protocols which do not exist in the specification: SLIM_HARD_ISO;
> SLIM_AUTO_ISO.

The enums are more SW representation (and not 1-1 mapping). Difference
between HARD_ISO and AUTO_ISO with example:
Let's say the root frequency is 24.576MHz. then all 4K family channels
(sample rate multiple of 4K) can run isochronously, and all 11.025KHz
channel can run with good efficiency.
So if a client wants 11.025KHz and is does not want to do flow-control at
this root frequency, then the client can specify AUTO_ISO to get the next
available isochronous frequency.

> I suggest that term "enumeration address" should be used.
>
Thank you for catching this. I will change it where-ever applicable.

> b) Similarly to (a) the driver may be probed before the device has
> been given a logical address (LA). This makes sense in the case of
> driver that turns on the device (say via gpio) once the bus has
> booted. However, the driver then needs to sit and poll
> slim_get_logical_addr() until the logical address.
This is not the case anymore.
While taking care of the comments for RFC, I have introduced a completion
that will be signalled when LA is given to the device. The driver can wait
on that completion (wait_enum) instead of polling.

Regards
Sagar
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

