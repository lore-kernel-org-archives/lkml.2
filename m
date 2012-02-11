Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab2BKMbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 07:31:38 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:51622 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab2BKMbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 07:31:37 -0500
Message-ID: <4F365FA8.40600@bootc.net>
Date: Sat, 11 Feb 2012 12:31:36 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] firewire-sbp2: Ignore SBP-2 targets on the local
 node
References: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net>	<1328881314-26544-1-git-send-email-bootc@bootc.net>	<1328881314-26544-3-git-send-email-bootc@bootc.net> <20120211122832.25f00d59@stein> <4F365C01.6000807@ladisch.de>
In-Reply-To: <4F365C01.6000807@ladisch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 12:16, Clemens Ladisch wrote:
> Stefan Richter wrote:
>> On Feb 10 Chris Boot wrote:
>>> The firewire-sbp2 module tries to login to an SBP-2/3 target even when
>>> it is running on the local node, which fails because of the inability to
>>> fetch data from DMA mapped regions using firewire transactions on the
>>> local node.
>>
>> In the long run, we might want to support target and initiator set up to
>> reside on the same node and talking to each other via loopback, if
>> somebody really needs it and if it can be done with reasonably little
>> effort.
>
> Handling SBP data packets in the driver is required if we do not want to
> allow remote DMA from any device that claims to be a target.  This is
> somewhere on my todo list.

I just made it ignore it completely as it just doesn't work at all at 
the moment. If the firewire-sbp2 driver is changed so it could work in 
future, then a module option or similar sounds like a good idea.

>>> +	/* ignore targets on the local node */
>>> +	if (device->node == device->card->local_node) {
>>> +		dev_set_drvdata(&unit->device, NULL);
>>> +		return 0;
>>> +	}
>>
>> But I do wonder:  Shouldn't this be implemented by returning from the
>> driver probe method with an error?
>
> AFAIK zero means "attach", and the drvdata pointer has no meaning to the
> core.
>
>> If so, which errno should be returned?
>
> -ENODEV or -ENXIO.

Perhaps, but the meaning of those isn't quite what is happening here. We 
aren't saying the device doesn't exist or is inaccessible, just that we 
don't want to talk to it...

Chris

-- 
Chris Boot
bootc@bootc.net
