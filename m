Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab2JWXDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:03:40 -0400
Received: from mail.candelatech.com ([208.74.158.172]:40265 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab2JWXDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:03:39 -0400
Message-ID: <50872243.1050308@candelatech.com>
Date: Tue, 23 Oct 2012 16:03:31 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, cardoe@cardoe.com, kaber@trash.net,
        netdev@vger.kernel.org, systemd-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vlan: set sysfs device_type to 'vlan'
References: <1350885237-12998-1-git-send-email-cardoe@cardoe.com>  <20121023.023647.2164665243829038911.davem@davemloft.net>  <5086C256.20202@candelatech.com> <1351032742.5283.69.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1351032742.5283.69.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 03:52 PM, Ben Hutchings wrote:
> On Tue, 2012-10-23 at 09:14 -0700, Ben Greear wrote:
>> On 10/22/2012 11:36 PM, David Miller wrote:
>>> From: Doug Goldstein <cardoe@cardoe.com>
>>> Date: Mon, 22 Oct 2012 00:53:57 -0500
>>>
>>>> Sets the sysfs device_type to 'vlan' for udev. This makes it easier for
>>>> applications that query network information via udev to identify vlans
>>>> instead of using strrchr().
>>>>
>>>> Signed-off-by: Doug Goldstein <cardoe@cardoe.com>
>>>
>>> You're extremely misguided.  This change, in fact, makes it ten times
>>> harder for such applications to query such devices.
>>
>> If the application doesn't care, it can use the old way (which at least
>> for me, involves string-comparing the driver name ethtool returns, which
>> sucks at best).
>
> The 'old way' that has only worked since Linux 2.6.29 (3.5 years)?
>
> The 'right way' seems to be to query for VLAN information through
> netlink.  But that has only worked since Linux 2.6.23 (5 years ago).
> The real 'old way' is to use SIOCGIFVLAN. :-/

Oh, I have the SIOCGIFVLAN fallback in place too.

But none of this is easy from a shell script, where reading a sysfs
file is quite easy.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

