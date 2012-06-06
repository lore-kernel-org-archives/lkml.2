Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2FFINe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:13:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57555 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2FFINa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:13:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6733"; a="198194203"
Message-ID: <dd131f3f86e367a47b3528015cde9dd9.squirrel@www.codeaurora.org>
In-Reply-To: <20120604171344.GA15837@plastictigers.com>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
    <20120601001617.GA16311@plastictigers.com>
    <74993ac9d11db0db7080c0864daef397.squirrel@www.codeaurora.org>
    <20120604171344.GA15837@plastictigers.com>
Date: Wed, 6 Jun 2012 01:13:30 -0700 (PDT)
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
From: "Sagar Dharia" <sdharia@codeaurora.org>
To: "Marc Butler" <marc@plastictigers.com>
Cc: "Sagar Dharia" <sdharia@codeaurora.org>, davidb@codeaurora.org,
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

> I understand it is not a 1-to-1 mapping. However it *is* used as such:
>
>  wbuf[2] = (u8)((segdist & 0xF00) >> 8) | (slc->prop.prot << 4);
>
> which results in NEXT_DEFINE_CHANNEL messages with an invalid TP
> field.
Yes, thanks for catching this. I will make changes to rectify this.

>
> Yes, my mistake. The driver wouldn't have to poll if there was another
> callback. So I don't see how the completion mechanism is superior: it
> forces a synchronous interface to asynchronous events, or the driver
> developer has to work around it.
The get_logical_address API itself doesn't take completion. Completion is
part of slim_device structure so that the slim_device's driver can wait on
it whenever it needs LA for the first time. (Framework signals completion
on a slim_device when it gets enumerated)
If callback is preferred, I will change it to callback.

Regards-
Sagar

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

