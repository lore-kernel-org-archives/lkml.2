Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1DTIiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:38:54 -0400
Received: from liner.boxed.no ([89.250.115.71]:33608 "EHLO liner.boxed.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1DTIix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:38:53 -0400
Message-ID: <4DAE9B9B.90509@boxed.no>
Date: Wed, 20 Apr 2011 10:38:51 +0200
From: Alexander Hoogerhuis <alexh@boxed.no>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: A patch you wrote some time ago (aka: "[patch 41/54] ICMP: Fix
 icmp_errors_use_inbound_ifaddr sysctl")
References: <20110419165411.GO9569@sequoia.sous-sol.org> <4DAE9824.10802@trash.net>
In-Reply-To: <4DAE9824.10802@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.04.2011 10:24, Patrick McHardy wrote:
>
> That might be a possibility to fix this for your case. But I'm
> wondering why you're turning this on at all and not have routing
> decide the correct source address?

Not a whole lot of tuning, but trying to figure why this would not work 
as any other VRRP implementation would work on other routers/OSes.

My case seems to be a general problem for ICMP errors, as the IP stack 
tends to want to listen more to advice coming back with the source IP of 
the gateway, not a third party.

If you have two machines (A and B) run VRRP and share an IP (C), then 
any ICMP redirect should have the VRRP IP as source (C), and the way it 
works today (with or without sysctl_icmp_errors_use_inbound_ifaddr) is 
that it will have the source set to the primary IP of the source interface.

I suspect this holds for any other ICMP message sent back to hosts in 
the connected network as well, such as PMTU-related issues, etc.

In my case nodes in the connected subnet would get ICMP redirects from 
the primary IPs, and thus not listen to them as they are arriving from 
nodes not listen in the list of known gateways.

It would make more sense when returning ICMP messages the source IP 
would be the actual IP it is recveied on, not the primary IP of the 
interface.

mvh,
A
-- 
Alexander Hoogerhuis | http://no.linkedin.com/in/alexh
Boxed Solutions AS   | +47 908 21 485 - alexh@boxed.no
"Given enough eyeballs, all bugs are shallow." -Eric S. Raymond
