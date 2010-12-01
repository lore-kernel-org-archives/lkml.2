Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0LAQgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:36:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34375 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab0LAQgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:36:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6183"; a="65039274"
Message-ID: <4CF6797A.2010807@codeaurora.org>
Date: Wed, 01 Dec 2010 11:36:10 -0500
From: Stephen Caudle <scaudle@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11pre) Gecko/20100922 Shredder/3.1.5pre
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        adharmap@codeaurora.org, linux-kernel@vger.kernel.org, miltonm@bga.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] [ARM] gic: Unmask private interrupts on all cores
 during IRQ enable
References: <1288820762-16077-1-git-send-email-scaudle@codeaurora.org> <20101130180718.GB8521@n2100.arm.linux.org.uk>
In-Reply-To: <20101130180718.GB8521@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2010 01:07 PM, Russell King - ARM Linux wrote:
> Sorry, missed this.
>
> If it's a private peripheral, it can only be accessed from its associated
> CPU.  What that means is you don't want to enable the interrupt on other
> CPUs as the peripheral may not be present or initialized on that CPU.

Understood.  But the alternative is to require all code that requests a 
PPI to have to enable the IRQ on the other cores.  This seems 
unreasonable to me.

> So I'm nervous about this change - architecturally it feels like the
> wrong thing to do to take the PPI interrupts through the generic IRQ
> infrastructure.

What do suggest as an alternative to this solution?  Creating separate 
IRQ numbers for each core (per PPI) doesn't seem to scale well as the 
number of cores increase.

~Stephen

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
