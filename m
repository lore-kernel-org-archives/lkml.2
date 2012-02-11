Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2BKMQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 07:16:38 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36636 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab2BKMQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 07:16:37 -0500
X-Sasl-enc: F0tzPA4yX/RhsTOOezDSKnRyxfgNUbbb5C6JUdNutR4g 1328962595
Message-ID: <4F365C01.6000807@ladisch.de>
Date: Sat, 11 Feb 2012 13:16:01 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Chris Boot <bootc@bootc.net>, Greg KH <gregkh@linuxfoundation.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] firewire-sbp2: Ignore SBP-2 targets on the local
 node
References: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net>	<1328881314-26544-1-git-send-email-bootc@bootc.net>	<1328881314-26544-3-git-send-email-bootc@bootc.net> <20120211122832.25f00d59@stein>
In-Reply-To: <20120211122832.25f00d59@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> On Feb 10 Chris Boot wrote:
>> The firewire-sbp2 module tries to login to an SBP-2/3 target even when
>> it is running on the local node, which fails because of the inability to
>> fetch data from DMA mapped regions using firewire transactions on the
>> local node.
>
> In the long run, we might want to support target and initiator set up to
> reside on the same node and talking to each other via loopback, if
> somebody really needs it and if it can be done with reasonably little
> effort.

Handling SBP data packets in the driver is required if we do not want to
allow remote DMA from any device that claims to be a target.  This is
somewhere on my todo list.

>> +	/* ignore targets on the local node */
>> +	if (device->node == device->card->local_node) {
>> +		dev_set_drvdata(&unit->device, NULL);
>> +		return 0;
>> +	}
>
> But I do wonder:  Shouldn't this be implemented by returning from the
> driver probe method with an error?

AFAIK zero means "attach", and the drvdata pointer has no meaning to the
core.

> If so, which errno should be returned?

-ENODEV or -ENXIO.


Regards,
Clemens
