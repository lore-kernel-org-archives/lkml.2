Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab1F0Psy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:48:54 -0400
Received: from mail04.solnet.ch ([212.101.4.138]:56274 "EHLO mail04.solnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab1F0Psw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:48:52 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jun 2011 11:48:52 EDT
Message-ID: <4E08A4C9.60709@openelec.tv>
Date: Mon, 27 Jun 2011 17:42:01 +0200
From: Stephan Raue <mailinglists@openelec.tv>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-3.0-rc4, wlan0 device is not showing with ifconfig
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

running linux-3.0-rc4 my wlan0 device is not showing with ifconfig, even 
if the driver (r8712u) loads successfull.

strace ifconfig shows:

ioctl(3, SIOCGIFFLAGS, {ifr_name="wlan0", 
ifr_flags=IFF_BROADCAST|IFF_MULTICAST}) = 0
ioctl(3, SIOCGIFHWADDR, {ifr_name="wlan0", 
ifr_hwaddr=80:1f:02:0b:5d:9a}) = 0
ioctl(3, SIOCGIFMETRIC, {ifr_name="wlan0", ifr_metric=0}) = 0
ioctl(3, SIOCGIFMTU, {ifr_name="wlan0", ifr_mtu=1500}) = 0
ioctl(3, SIOCGIFMAP, {ifr_name="wlan0", ifr_map={mem_start=0, mem_end=0, 
base_addr=0, irq=0, dma=0, port=0}}) = 0
ioctl(3, SIOCGIFTXQLEN, {ifr_name="wlan0", ifr_qlen=1000}) = 0
ioctl(3, SIOCGIFADDR, {ifr_name="wlan0", ???}) = -1 EADDRNOTAVAIL 
(Cannot assign requested address)
close(3)                                = 0

the interface will be shown after i setup a ipadress manually:

ifconfig wlan0 192.68.0.13
strace ifconfig

ioctl(3, SIOCGIFFLAGS, {ifr_name="wlan0", 
ifr_flags=IFF_UP|IFF_BROADCAST|IFF_MULTICAST}) = 0
ioctl(3, SIOCGIFHWADDR, {ifr_name="wlan0", 
ifr_hwaddr=80:1f:02:0b:5d:9a}) = 0
ioctl(3, SIOCGIFMETRIC, {ifr_name="wlan0", ifr_metric=0}) = 0
ioctl(3, SIOCGIFMTU, {ifr_name="wlan0", ifr_mtu=1500}) = 0
ioctl(3, SIOCGIFMAP, {ifr_name="wlan0", ifr_map={mem_start=0, mem_end=0, 
base_addr=0, irq=0, dma=0, port=0}}) = 0
ioctl(3, SIOCGIFTXQLEN, {ifr_name="wlan0", ifr_qlen=1000}) = 0
ioctl(3, SIOCGIFADDR, {ifr_name="wlan0", ifr_addr={AF_INET, 
inet_addr("168.0.0.13")}}) = 0
ioctl(3, SIOCGIFDSTADDR, {ifr_name="wlan0", ifr_dstaddr={AF_INET, 
inet_addr("168.0.0.13")}}) = 0
ioctl(3, SIOCGIFBRDADDR, {ifr_name="wlan0", ifr_broadaddr={AF_INET, 
inet_addr("168.0.255.255")}}) = 0
ioctl(3, SIOCGIFNETMASK, {ifr_name="wlan0", ifr_netmask={AF_INET, 
inet_addr("255.255.0.0")}}) = 0

is this problem known and is there a fix for this?

many thanks

Stephan
