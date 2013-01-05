Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3AEKQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 05:16:30 -0500
Received: from mout.gmx.net ([212.227.15.19]:52156 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab3AEKQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 05:16:28 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/ByeIFIffB/YkIoBFYM/ZmoXF3r511swGJDRmX2f
	YUvcB2XBIO/2IH
Message-ID: <50E7FD79.1080605@gmx.de>
Date: Sat, 05 Jan 2013 11:16:25 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Maxim Krasnyansky <maxk@qti.qualcomm.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: why does kernel 3.8-rc1 put all TAP devices into state RUNNING during
 boot
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At my stable Gentoo Linux I'm observed a change behaviour for the
configured TAP devices after the boot process.

$ diff 3.7.1 3.8.0-rc1+ | grep UP
< br0: flags=4355<UP,BROADCAST,PROMISC,MULTICAST>  mtu 1500
> br0: flags=4419<UP,BROADCAST,RUNNING,PROMISC,MULTICAST>  mtu 1500
< tap0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
> tap0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500


May I ask you if this changed behaviour is intended ?


FWIW I configured those devices at that system in this way :

$ head -n 20 /etc/conf.d/net
# /etc/conf.d/net
#

#       KVM
#
bridge_br0="tap0 tap1 tap2 tap3"
config_br0="192.168.0.254/8"
brctl_br0="setfd 0
sethello 10
stp off"
rc_net_br0_need="net.tap0 net.tap1 net.tap2 net.tap3"

config_tap0="null"
tuntap_tap0="tap"
tunctl_tap0="-u <me>"

...

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
