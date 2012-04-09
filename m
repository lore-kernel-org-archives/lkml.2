Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2DIXKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:10:15 -0400
Received: from [195.159.66.52] ([195.159.66.52]:33575 "EHLO lauken.nlc.no"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab2DIXKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:10:14 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Apr 2012 19:10:14 EDT
Message-ID: <aab6c360d4fab33ca3fe38b3d007389c.squirrel@nlc.no>
Date: Tue, 10 Apr 2012 01:00:44 +0200
Subject: Is this intended design, or a bug? Missing event for gateway being
 deleted
From: "Stian Skjelstad" <stian@nixia.no>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry if this has been discussed before, but my google searches didn't
give me any good hints so:

I'm using rtnetlink for a project and I noticed a non-consistent behavior.
When I tear down (the last) ip address, the default gateway is removed,
but it is not announced on the netlink socket. This can also be verified
using "ip monitor". This is tested with linux kernel version 3.2.6 on ARM.





# ip monitor &
# ip addr add 10.0.0.2/8 dev eth0
2: eth0    inet 10.0.0.2/8 scope global eth0
local 10.0.0.2 dev eth0  table local  proto kernel  scope host  src
10.0.0.2 10.0.0.0/8 dev eth0  proto kernel  scope link  src 10.0.0.2
broadcast 10.0.0.0 dev eth0  table local  proto kernel  scope link  src
10.0.0.2
broadcast 10.255.255.255 dev eth0  table local  proto kernel  scope link 
src 10.0.0.2
# ip route add via 10.0.1.22
default via 10.0.1.2 dev eth0
# ip addr del 10.0.0.2/8 dev eth0
Deleted 2: eth0    inet 10.0.0.2/8 scope global eth0
Deleted 10.0.0.0/8 dev eth0  proto kernel  scope link  src 10.0.0.2
Deleted broadcast 10.255.255.255 dev eth0  table local  proto kernel 
scope link  src 10.0.0.2
Deleted broadcast 10.0.0.0 dev eth0  table local  proto kernel  scope link
 src 10.0.0.2
Deleted local 10.0.0.2 dev eth0  table local  proto kernel  scope host 
src 10.0.0.2

(No Deleted default via line here)


Stian Skjelstad



