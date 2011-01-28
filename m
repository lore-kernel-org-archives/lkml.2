Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1A1D3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 22:29:41 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64517 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1A1D3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 22:29:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6239"; a="72069678"
Message-ID: <4D423823.4070009@codeaurora.org>
Date: Thu, 27 Jan 2011 19:29:39 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>, Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Richard Zhao <linuxzsc@gmail.com>
Subject: Re: Locking in the clk API
References: <201101111744.59712.jeremy.kerr@canonical.com>	<20110111103929.GN24920@pengutronix.de>	<AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>	<4D386ABF.9060908@fluff.org>	<20110120190822.GK6335@n2100.arm.linux.org.uk>	<4D3932B4.8010904@codeaurora.org>	<20110121094042.GD13235@n2100.arm.linux.org.uk>	<4D40F5CC.6080809@codeaurora.org>	<20110127085438.GA25239@n2100.arm.linux.org.uk>	<4D41D5EC.6030405@codeaurora.org>	<20110127204354.GB1597@n2100.arm.linux.org.uk> <20110127210729.79eef2c1@lxorguk.ukuu.org.uk>
In-Reply-To: <20110127210729.79eef2c1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 01:07 PM, Alan Cox wrote:
>>> For internal tree purposes, does .set_termios need to be atomic? Can it
>>> grab mutexes instead of spinlock?
>>
>> I think I already answered that question above where I said "protect
>> against the interrupt handler accessing the port->* stuff".
>
> I'm not sure you answered it correctly however as the locking nowdays is
> a bit different.
>
> Architecturally the termios handling doesn't need a spin lock nor is it
> called under one. In fact it's vital this is the case because of USB.

Thanks for the clarification Alan. This is what I was looking for.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
