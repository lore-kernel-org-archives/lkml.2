Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab1KISW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:22:29 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:14663 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751010Ab1KISW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:22:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAPLDuk4Y9geI/2dsb2JhbAAMNoR9ow6FEAEBAQEDIwRSEAsOCgICBSECAg8CRgYNAQcBAa1EkkSBMIc5gRYEiAyeKQ
X-IronPort-AV: E=Sophos;i="4.69,484,1315195200"; 
   d="scan'208";a="147200048"
Message-ID: <4EBAC4E2.70808@teksavvy.com>
Date: Wed, 09 Nov 2011 13:22:26 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
References: <4EA89972.5060101@teksavvy.com>  <20111026.194045.2019668159403582571.davem@davemloft.net>  <4EA8B283.3010105@teksavvy.com>  <20111026.221719.2216112919297458522.davem@davemloft.net>  <4EB19BBE.5050602@teksavvy.com> <1320266549.2782.21.camel@bwh-desktop>  <4EBAA967.10403@teksavvy.com> <1320856444.18929.78.camel@deadeye>  <4EBAAEA5.1060408@teksavvy.com> <4EBAB0EA.1050102@teksavvy.com>  <4EBAB643.8020603@teksavvy.com> <1320859911.2781.1.camel@bwh-desktop>  <4EBABAFD.6050604@teksavvy.com> <1320860895.2781.6.camel@bwh-desktop>
In-Reply-To: <1320860895.2781.6.camel@bwh-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-09 12:48 PM, Ben Hutchings wrote:
> On Wed, 2011-11-09 at 12:40 -0500, Mark Lord wrote:
>> On 11-11-09 12:31 PM, Ben Hutchings wrote:
>>> On Wed, 2011-11-09 at 12:20 -0500, Mark Lord wrote:
>>>> On 11-11-09 11:57 AM, Mark Lord wrote:
>>>>> On 11-11-09 11:47 AM, Mark Lord wrote:
>>>>> ..
>>>>>> Note:  I'm looking at smsc95xx.c and smsc75xx.c for examples,
>>>>>> and they both have the same problem I'll have here:
>>>>>>
>>>>>> How to update the csum settings atomically.
>>>>>> A spinlock is no good, because config register access is over USB.
>>>>>
>>>>> Nevermind.. a slight change in the logic and all is well again.
>>>> ..
>>>>
>>>> Or even simpler (below).  I don't think this method requires any
>>>> extra locking, but I'm still open to persuasion.  :)
>>>
>>> Looks reasonable, but...
>>>
>>>> static int ax88772b_set_features(struct net_device *netdev, u32 features)
>>>> {
>>>>         struct usbnet *dev = netdev_priv(netdev);
>>>>         struct ax88772b_data *priv = (struct ax88772b_data *)dev->driver_priv;
>>>>         u16 tx_csum = 0, rx_csum = 0;
>>>>
>>>>         priv->features = features & (NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
>>>
>>> ...why do you need priv->features at all?
>>
>>
>> There's code elsewhere that takes action under some conditions
>> based on the current setting of the NETIF_F_RXCSUM flag.
>>
>> I don't claim to fully understand what's going on,
>> but it doesn't care much about races on set/clear of the flag.
> 
> And it can use dev->features.

Oh, is that kosher?    Looks great to me!


