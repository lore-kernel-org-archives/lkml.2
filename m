Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab2BKPrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 10:47:48 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35590 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159Ab2BKPrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 10:47:32 -0500
X-Sasl-enc: ginZVdNoVnQN1HUHHgGe6TdeHSEJ90s5fVqI9OdL2QEc 1328975250
Message-ID: <4F368D6F.90702@ladisch.de>
Date: Sat, 11 Feb 2012 16:46:55 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Chris Boot <bootc@bootc.net>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] firewire-sbp2: Ignore SBP-2 targets on the local
 node
References: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net>	<1328881314-26544-1-git-send-email-bootc@bootc.net>	<1328881314-26544-3-git-send-email-bootc@bootc.net> <20120211122832.25f00d59@stein> <4F365C01.6000807@ladisch.de> <4F365FA8.40600@bootc.net>
In-Reply-To: <4F365FA8.40600@bootc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Boot wrote:
> On 11/02/2012 12:16, Clemens Ladisch wrote:
>> Stefan Richter wrote:
>>> On Feb 10 Chris Boot wrote:
>>>> +    /* ignore targets on the local node */
>>>> +    if (device->node == device->card->local_node) {
>>>> +        dev_set_drvdata(&unit->device, NULL);
>>>> +        return 0;
>>>> +    }
>>>
>>> But I do wonder:  Shouldn't this be implemented by returning from the
>>> driver probe method with an error? If so, which errno should be returned?
>>
>> -ENODEV or -ENXIO.
>
> Perhaps,

It's what really_probe() in drivers/base/dd.c requires:

	if (ret != -ENODEV && ret != -ENXIO) {
		/* driver matched but the probe failed */
		printk(KERN_WARNING
		       "%s: probe of %s failed with error %d\n",
		       drv->name, dev_name(dev), ret);
	} else {
		pr_debug("%s: probe of %s rejects match %d\n",
		       drv->name, dev_name(dev), ret);
	}

> but the meaning of those isn't quite what is happening here. We aren't
> saying the device doesn't exist or is inaccessible, just that we don't
> want to talk to it...

ENODEV does not mean "no device" but "no _such_ device".


Regards,
Clemens
