Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2AYPZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:25:49 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46188 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634Ab2AYPZr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:25:47 -0500
MIME-Version: 1.0
X-Originating-IP: [59.167.234.130]
In-Reply-To: <CAEP_g=9H9dV9=qtFPh4YeTNQ-t+UZGw-YqZ6hFWVNXjFy+GCZg@mail.gmail.com>
References: <20120123.134352.1621146585245670953.davem@davemloft.net>
	<CAGsizzJnQ6b6eSC0ZnAtFguU7_xDfWFPSY6L4DWXc24F+Ts2XQ@mail.gmail.com>
	<CAOzFzEjE7b-Y+_vOWeBKbHDkURRcYXomSTcwB91vKHVWQxBVsg@mail.gmail.com>
	<20120124.230203.1478271172075708903.davem@davemloft.net>
	<CAEP_g=9H9dV9=qtFPh4YeTNQ-t+UZGw-YqZ6hFWVNXjFy+GCZg@mail.gmail.com>
Date: Thu, 26 Jan 2012 02:25:46 +1100
Message-ID: <CAOzFzEiv3da9zbCF6goBw6uWveq1FGGz9nn1KxnOx=R064xzeQ@mail.gmail.com>
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: Joseph Glanville <joseph.glanville@orionvm.com.au>
To: David Miller <davem@davemloft.net>
Cc: Jesse Gross <jesse@nicira.com>, steweg@ynet.sk, eric.dumazet@gmail.com,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry David, I think I might have failed to convey my meaning.

What I meant by only true L2 multipoint VPN is that Open vSwitch
cannot fuffil this on it's own at this time. Without NVGRE or VXLAN
support its required to implement some logic in a Openflow controller
to achieve this functionality. However once NVGRE/VXLAN is complete
advanced users can setup a VXLAN domain to accomplish this.

Open vSwitch fufils a different role to this simplistic VPN. The point
of OVS is to be a generic L2 forwarding plane for Software Defined
Networking (SDN) solutions, an effective cornerstone of network
virtualisation.
If anything it's more analgous to Solaris's Crossbow or FreeBSD's
VIMAGE in that it's more of a wholistic solution to the problem
cappable of solving arbitarily difficult fowarding problems with the
assistance of userspace logic.
As such given a controller that implemented the tunnel endpoint
learning, establishment of tunnels between every endpoint and a
broadcast tunnel you could build a solution that is on par with this
patch if not better.

The 2 are fundamentally different usecases however - many people don't
need or couldn't care less about SDN and just want a mulitpoint VPN or
L3 encapsulation of L2 between bridges, this is an ideal solution for
these simpler usecases.

The primary users of Open vSwitch are likely to be large virtual
environments with complex network topologies and well defined virtual
networking needs.
For this class of users the Linux Bridge module + static tunneling
isn't going to cut it without some very clever control software -
which is why OVS exists.

I think there is quite some way to go yet integrating OVS into the
kernel and making use of all of it's advanced features but I would say
it's far from useless and that in the long run it's inclusion will be
very rewarding.

Kind regards,
Joseph.

On 25 January 2012 18:11, Jesse Gross <jesse@nicira.com> wrote:
> On Tue, Jan 24, 2012 at 8:02 PM, David Miller <davem@davemloft.net> wrote:
>> From: Joseph Glanville <joseph.glanville@orionvm.com.au>
>> Date: Wed, 25 Jan 2012 14:48:37 +1100
>>
>>> The reason why this patch is useful is that it stands to be the only
>>> true mulitpoint L2 VPN with a kernel space forwarding plane.
>>
>> So what you're telling me is that I added this huge openvswitch
>> thing essentially for nothing?
>
> I think it's actually the opposite - Open vSwitch can be used to
> implement this type of thing as well as for many other use cases.  On
> the other hand, even when implementing a multipoint L2 solution it can
> be useful to have additional levels of control but you can't do that
> with this patch because it essentially statically glues together
> tunneling and bridging.



-- 
Founder | Director | VP Research
Orion Virtualisation Solutions | www.orionvm.com.au | Phone: 1300 56
99 52 | Mobile: 0428 754 846
