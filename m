Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0LUXqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:46:03 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43502 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0LUXqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:46:00 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6204"; a="67577303"
Message-ID: <2c27ccc1dd4db9a31cd961f0ffaed886.squirrel@www.codeaurora.org>
In-Reply-To: <20101215134406.3a634aa8@nehalam>
References: <1292437866-11652-1-git-send-email-nvishwan@codeaurora.org>
    <20101215134406.3a634aa8@nehalam>
Date: Tue, 21 Dec 2010 15:45:45 -0800 (PST)
Subject: Re: [PATCH] msm: rmnet: msm rmnet smd virtual ethernet driver
From: nvishwan@codeaurora.org
To: "Stephen Hemminger" <shemminger@vyatta.com>
Cc: "Niranjana Vishwanathapura" <nvishwan@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Brian Swetland" <swetland@google.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 15 Dec 2010 10:31:06 -0800
> Niranjana Vishwanathapura <nvishwan@codeaurora.org> wrote:
>
>> +
>> +static DECLARE_TASKLET(smd_net_data_tasklet, smd_net_data_handler, 0);
>> +
>> +static void smd_net_notify(void *_dev, unsigned event)
>> +{
>> +	if (event != SMD_EVENT_DATA)
>> +		return;
>> +
>> +	smd_net_data_tasklet.data = (unsigned long) _dev;
>> +
>> +	tasklet_schedule(&smd_net_data_tasklet);
>> +}
>> +
>
> Rather than having private tasklet, maybe using NAPI
> would be better?
>
> Also since you are already in tasklet, no need to call netif_rx()
> when receiving packet; instead use netif_receive_skb directly.
>
> --
>

NAPI will not buy much as the SMD transport doesn't provide a machanism to
stop interrupts.  I will consider using NAPI in the future (it requires
performance testing on lot of different targets).

However, I can replace netif_rx() by netif_receive_skb() and send out new
patch

