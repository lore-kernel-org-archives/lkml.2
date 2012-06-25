Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2FYXso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:48:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33474 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2FYXsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:48:43 -0400
Message-ID: <4FE8F8D8.1050009@gmail.com>
Date: Mon, 25 Jun 2012 16:48:40 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ddaney.cavm@gmail.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, david.daney@cavium.com
Subject: Re: [PATCH 1/4] netdev/phy: Handle IEEE802.3 clause 45 Ethernet PHYs
References: <1340411056-18988-2-git-send-email-ddaney.cavm@gmail.com>	<20120625.153440.17010814246237639.davem@davemloft.net>	<4FE8F01B.2020207@gmail.com> <20120625.163355.2058784474741116830.davem@davemloft.net>
In-Reply-To: <20120625.163355.2058784474741116830.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 04:33 PM, David Miller wrote:
> From: David Daney<ddaney.cavm@gmail.com>
> Date: Mon, 25 Jun 2012 16:11:23 -0700
>
>> Do you realize that at the time get_phy_device() is called, there is
>> no PHY device?  So there can be no attribute, nor are we passing a
>> register address.  Neither of these suggestions apply to this
>> situation.
>>
>> We need to know a priori if it is c22 or c45.  So we need to
>> communicate the type somehow to get_phy_device().  I chose an unused
>> bit in the addr parameter to do this, another option would be to add a
>> separate parameter to get_phy_device() specifying the type.
>
> Then pass it in to the get() routine and store the attribute there
> in the device we end up with.

OK.

addr has only 5 significant bits, and the patch *does* pass the 
information (c22 vs. c45) in one of the high order bits.  So it is 
essentially as you say, but you don't like the idea of multiplexing the 
arguments into a single int.

Therefore, I am going to propose that we add a 'flags' parameter to 
get_phy_device() and change the (two) callers.

Does that seem better (or at least acceptable)?

Or do you really want to pass the address of a (one bit) structure instead?

David Daney

>
> There are many parameters that go into a PHY register access, so
> we'll probably some day end up with a descriptor struct that the
> caller prepares on-stack to pass into the actual read/write ops
> via reference.
>
