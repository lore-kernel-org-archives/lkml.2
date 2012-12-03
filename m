Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2LCK0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:26:08 -0500
Received: from borg.uu3.net ([87.99.63.19]:53037 "EHLO borg.uu3.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab2LCK0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:26:07 -0500
X-Greylist: delayed 1733 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2012 05:26:07 EST
Date: Mon, 3 Dec 2012 10:57:13 +0100 (CET)
From: borg@uu3.net
X-X-Sender: borg@cube
To: linux-kernel@vger.kernel.org
Subject: Patch using ipset match in policy routing.
Message-ID: <Pine.LNX.4.64.1212031042330.4310@cube>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Here comes the patch thats makes possible to use ipset
directly in ip rule (policy routing).
This makes such configuration easier, because
there is no need to have:
iptables -t mangle -A OUTPUT -m set --set ... -j MARK --set-mark 1
ip rule add fwmark 1 lookup 1

Additionaly, it fixes issue with wrong src addr for unconnected
protocols such as UDP, ICMP...
https://bugzilla.kernel.org/show_bug.cgi?id=16216

Brief question to google confirms that few people might have
interest in this patch.

ftp://borg.uu3.net/home/borg/patch/linux-2.6.27.62+ipset_routing.patch
ftp://borg.uu3.net/home/borg/patch/iproute2+ipset.patch

To install the patch, first you need to patch kernel using
ipset (4.5 preffered). Then, you apply this patch.
Additionaly, you need to patch iproute2 to use new match:
ip route add ipset <name> src|dst lookup <n>

The place for this is IPSET webpage I belive, but I mailing
it here because I have few concerns:
- Now this patch needs IPSET to be compiled into kernel (no modules)
   I would like to fix it
- I had to add 2 new function to API of IPSET, and so I probably
   doing something wrong.
- Patch is conditional: CONFIG_IP_NF_SET
   except in 2 places:
   size_t payload = NLMSG_ALIGN(sizeof(struct fib_rule_hdr))
   enum { ... } // FRA_* defs

   Not sure if this is correct way.

Sorry that patch is agaist old kernel. I just needed it fast
for monday and this one is run on 2 production boxes I need
this feature.

One box is already patched and is running fine (non SMP host).
No issues so far. I will compare CPU usage after roughty 24 hrs.

Second box is SMP and I will try to patch it ASAP.

Regards,
Borg
