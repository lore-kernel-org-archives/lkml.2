Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab2BKMcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 07:32:19 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:51638 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab2BKMcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 07:32:17 -0500
Message-ID: <4F365FD0.6060404@bootc.net>
Date: Sat, 11 Feb 2012 12:32:16 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] firewire-sbp2: Ignore SBP-2 targets on the local
 node
References: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net> <1328881314-26544-1-git-send-email-bootc@bootc.net> <1328881314-26544-3-git-send-email-bootc@bootc.net> <20120211125619.249c6884@stein>
In-Reply-To: <20120211125619.249c6884@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 11:56, Stefan Richter wrote:
> On Feb 10 Chris Boot wrote:
>> --- a/drivers/firewire/sbp2.c
>> +++ b/drivers/firewire/sbp2.c
>> @@ -1138,6 +1138,12 @@ static int sbp2_probe(struct device *dev)
>>   	struct Scsi_Host *shost;
>>   	u32 model, firmware_revision;
>>
>> +	/* ignore targets on the local node */
>> +	if (device->node == device->card->local_node) {
>> +		dev_set_drvdata(&unit->device, NULL);
>> +		return 0;
>> +	}
>
> I forgot:  This test can yield false negatives because card->local_node
> may change anytime.  Check device->is_local instead.

Oh. How did I miss that?! I'll get this changed...

Chris

-- 
Chris Boot
bootc@bootc.net
