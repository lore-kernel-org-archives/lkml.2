Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1AGJDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:03:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36244 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab1AGJDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:03:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nIzYijZuJaG/Mov0PDBW2famF2G4YibAxLVCT0vZ3yMAJly7MVfkJRzQ2eTLLfDDTZ
         bzRWPxD68OJa6UKHh1jLPYSCRV5ti5aOgye+6D0aC9k1U1Ykg4T9tC8HAXc0/RJiBymb
         7Q6kHP7kU7fbsjeUbD+4bNmPhswLhzMPSh+mI=
MIME-Version: 1.0
In-Reply-To: <1294361206.21580.7.camel@HP1>
References: <4D2634DE.2060907@gmail.com>
	<1294357941.21580.2.camel@HP1>
	<1294361206.21580.7.camel@HP1>
Date: Fri, 7 Jan 2011 09:03:39 +0000
Message-ID: <AANLkTikwcVPWKvWcsAUviL7DB2qtsAa4ZAksha00MhRr@mail.gmail.com>
Subject: Re: 2.6.37 vlans on bnx2 not functional, panic with tcpdump
From: selsinork <selsinork@gmail.com>
To: Michael Chan <mchan@broadcom.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 12:46 AM, Michael Chan <mchan@broadcom.com> wrote:
> May be you have management firmware running on your devices that can
> change the behavior.  Can you provide ethtool -i eth0 on both bnx2
> devices on your system?

This particular system has four onboard ports, a two port add-in card
and a single port fiber card all using bnx2, so I have some options to
try different devices if there's something different about them.
Details of all of them below.

Booting the same system back to 2.6.36 with the patch I mentioned
previously leaves me with a functioning network, so given it could be
management firmware related, why does it work on .36 but not .37 ?
The install is very stripped down, there's no udev or /sbin/hotplug
loading firmware behind my back as neither are installed. So firmware
is whatever comes with the kernel. Just having had a look, I see the
firmware provided with the kernel has changed in .37, but the output
of ethtool -i shows the same firmware being used with .36 and .37

Iain

02:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709
Gigabit Ethernet (rev 20)
02:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709
Gigabit Ethernet (rev 20)
03:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709
Gigabit Ethernet (rev 20)
03:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709
Gigabit Ethernet (rev 20)
04:00.0 RAID bus controller: Hewlett-Packard Company Smart Array G6
controllers (rev 01)
07:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709
Gigabit Ethernet (rev 20)
07:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709
Gigabit Ethernet (rev 20)
0a:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3)
0b:00.0 Ethernet controller: Broadcom Corporation NetXtreme II
BCM5708S Gigabit Ethernet (rev 12)

from 2.6.37:

root@64bit:~# ethtool -i eth0
driver: bnx2
version: 2.0.17
firmware-version: bc 5.2.2 NCSI 2.0.6
bus-info: 0000:02:00.0
root@64bit:~# ethtool -i eth1
driver: bnx2
version: 2.0.17
firmware-version: bc 5.2.2 NCSI 2.0.6
bus-info: 0000:02:00.1
root@64bit:~# ethtool -i eth2
driver: bnx2
version: 2.0.17
firmware-version: bc 5.2.2
bus-info: 0000:03:00.0
root@64bit:~# ethtool -i eth3
driver: bnx2
version: 2.0.17
firmware-version: bc 5.2.2
bus-info: 0000:03:00.1
root@64bit:~# ethtool -i eth4
driver: bnx2
version: 2.0.17
firmware-version: bc 5.2.2
bus-info: 0000:07:00.0
root@64bit:~# ethtool -i eth5
driver: bnx2
version: 2.0.17
firmware-version: bc 5.2.2
bus-info: 0000:07:00.1
root@64bit:~# ethtool -i eth6
driver: bnx2
version: 2.0.17
firmware-version: bc 1.9.6
bus-info: 0000:0b:00.0

from 2.6.36:

 ethtool -i eth1
driver: bnx2
version: 2.0.17
firmware-version: bc 5.2.2 NCSI 2.0.6
bus-info: 0000:02:00.1
