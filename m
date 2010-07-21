Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695Ab0GUGrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:47:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0GUGrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:47:49 -0400
Message-ID: <4C469808.5060308@redhat.com>
Date: Wed, 21 Jul 2010 08:47:36 +0200
From: Harald Hoyer <harald@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: shemminger@vyatta.com, bhutchings@solarflare.com, sassmann@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, gospo@redhat.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com,
        leedom@chelsio.com
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network interfaces
 with random MAC address
References: <20100720141816.16f0a939@nehalam>	<20100720.142045.32697196.davem@davemloft.net>	<4C469313.6010807@redhat.com> <20100720.233457.267367495.davem@davemloft.net>
In-Reply-To: <20100720.233457.267367495.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 08:34 AM, David Miller wrote:
> From: Harald Hoyer<harald@redhat.com>
> Date: Wed, 21 Jul 2010 08:26:27 +0200
>
>> On 07/20/2010 11:20 PM, David Miller wrote:
>>> From: Stephen Hemminger<shemminger@vyatta.com>
>>> Date: Tue, 20 Jul 2010 14:18:16 -0700
>>>
>>>> No one mentioned that the first octet of an Ethernet address already
>>>> indicates "software generated" Ethernet address. Per the standard,
>>>> if bit 1 is set it means address is locally assigned.
>>>>
>>>> static inline bool is_locally_assigned_ether(const u8 *addr)
>>>> {
>>>> 	return (addr[0]&   0x2) != 0;
>>>> }
>>>
>>> W00t!
>>>
>>> Indeed, can udev just use that?  :-)
>>
>> It already does:
>> see /lib/udev/rules.d/75-persistent-net-generator.rules
>
> So... why doesn't this work?

It works.. but the information, that the MAC is randomly generated would be 
valuable. So, for the non-random locally assigned MAC (with bit 1), we could 
easily make persistent rules based on the MAC, instead of completely ignoring 
them, like we do currently.
