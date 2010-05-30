Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0E3Xo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 19:44:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61818 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0E3Xoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 19:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=OxD0eFZodBrLfxcjPJtylclcT5mS9zT+332Iy4CPPPNIY20rd8w6jHtd7v5c7vzcKW
         dM17HMjdJKJc/fXYVnCo9/L4rU5QZkPY55R1V0PnuZE/LumBQ7QT+rEpiNz2nyDPaqPf
         8VQTDpHksNKa09LL1a0F/6CEN9hryeuA8P5pE=
MIME-Version: 1.0
Date: Mon, 31 May 2010 07:44:52 +0800
Message-ID: <AANLkTim5zUD18vmMeNSzo2o8UGg8pr8l1uPbSYmHamq8@mail.gmail.com>
Subject: About offload function of Virtio Nic
From: Amos Kong <kongjianjun@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, davem@davemloft.net, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Can I ask some question of the offloading function with Virtio-NIC?

I'm interested in KVM virtualization. The virtual NIC is different
from real hardward. And there is also a big distance between
Virtio-NIC and E1000-NIC.
The offloading function of Virtio-NIC close related with the function
of host's real hardware.
Associate Feature bits:
VIRTIO_NET_F_GUEST_...
VIRTIO_NET_F_HOST_...

---------------------------------------------------
command:
enable rx:  guest) # ethtool -K eth0
enable tx:  guest) # ethtool -K eth0
enable gs: guest) # ethtool -K eth0
enable tso: guest) # ethtool -K eth0
enable gso: guest) # ethtool -K eth0
enable lro: guest) # ethtool -K eth0
enable gro: guest) # ethtool -K eth0

Those steps work well with Virtual E1000-NIC, but it always fail when
using Virtio-NIC.

---------------------------------------------------
After setup, I have two check method. For example:
1. enable tso
2. check the output of 'ethtool -k eth0'
3. send large file from guest to host by scp, listen by tcpdump during
transferring file. and check if there contains some large
packet($length > 1514).

The check method works with Virtual E1000-NIC, but it always fail when
using Virtio-NIC.

---------------------------------------------------
My question:
1. How to setup offloading function of Virtio-NIC?
2. How about my check method of offloading function(transferring file,
check packet length by tcpdump)?
3. Is there some detail user guide for Virtio-NIC?



Best Regards,
Amos
