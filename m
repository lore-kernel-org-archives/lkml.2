Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1F0RbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 13:31:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47708 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1F0R3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 13:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rDHWv4dEGINHNwbHvWZYcv7fPjhpUJTUQa6C4qMjgmotWIdsP8RpCbBALbcbqoCxiN
         fKa64hZy+wT/7xWZuuzUmytQs/J4uj0uwJN22n5taaRZaYsT5sLkzvZJjoOd6u/jELVb
         m7up0Qc+HY86cQpKCehzy8ZvDsTMoGoRZGouI=
Subject: Re: linux-3.0-rc4, wlan0 device is not showing with ifconfig
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephan Raue <mailinglists@openelec.tv>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4E08A4C9.60709@openelec.tv>
References: <4E08A4C9.60709@openelec.tv>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 19:29:07 +0200
Message-ID: <1309195747.2532.81.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 27 juin 2011 à 17:42 +0200, Stephan Raue a écrit :
> Hi,
> 
> running linux-3.0-rc4 my wlan0 device is not showing with ifconfig, even 
> if the driver (r8712u) loads successfull.
> 
> strace ifconfig shows:
> 
> ioctl(3, SIOCGIFFLAGS, {ifr_name="wlan0", 
> ifr_flags=IFF_BROADCAST|IFF_MULTICAST}) = 0
> ioctl(3, SIOCGIFHWADDR, {ifr_name="wlan0", 
> ifr_hwaddr=80:1f:02:0b:5d:9a}) = 0
> ioctl(3, SIOCGIFMETRIC, {ifr_name="wlan0", ifr_metric=0}) = 0
> ioctl(3, SIOCGIFMTU, {ifr_name="wlan0", ifr_mtu=1500}) = 0
> ioctl(3, SIOCGIFMAP, {ifr_name="wlan0", ifr_map={mem_start=0, mem_end=0, 
> base_addr=0, irq=0, dma=0, port=0}}) = 0
> ioctl(3, SIOCGIFTXQLEN, {ifr_name="wlan0", ifr_qlen=1000}) = 0
> ioctl(3, SIOCGIFADDR, {ifr_name="wlan0", ???}) = -1 EADDRNOTAVAIL 
> (Cannot assign requested address)
> close(3)                                = 0
> 
> the interface will be shown after i setup a ipadress manually:
> 
> ifconfig wlan0 192.68.0.13
> strace ifconfig
> 
> ioctl(3, SIOCGIFFLAGS, {ifr_name="wlan0", 
> ifr_flags=IFF_UP|IFF_BROADCAST|IFF_MULTICAST}) = 0
> ioctl(3, SIOCGIFHWADDR, {ifr_name="wlan0", 
> ifr_hwaddr=80:1f:02:0b:5d:9a}) = 0
> ioctl(3, SIOCGIFMETRIC, {ifr_name="wlan0", ifr_metric=0}) = 0
> ioctl(3, SIOCGIFMTU, {ifr_name="wlan0", ifr_mtu=1500}) = 0
> ioctl(3, SIOCGIFMAP, {ifr_name="wlan0", ifr_map={mem_start=0, mem_end=0, 
> base_addr=0, irq=0, dma=0, port=0}}) = 0
> ioctl(3, SIOCGIFTXQLEN, {ifr_name="wlan0", ifr_qlen=1000}) = 0
> ioctl(3, SIOCGIFADDR, {ifr_name="wlan0", ifr_addr={AF_INET, 
> inet_addr("168.0.0.13")}}) = 0
> ioctl(3, SIOCGIFDSTADDR, {ifr_name="wlan0", ifr_dstaddr={AF_INET, 
> inet_addr("168.0.0.13")}}) = 0
> ioctl(3, SIOCGIFBRDADDR, {ifr_name="wlan0", ifr_broadaddr={AF_INET, 
> inet_addr("168.0.255.255")}}) = 0
> ioctl(3, SIOCGIFNETMASK, {ifr_name="wlan0", ifr_netmask={AF_INET, 
> inet_addr("255.255.0.0")}}) = 0
> 
> is this problem known and is there a fix for this?

Pretty normal behavior, if your device is not "UP"

To see all devices, even DOWN ones, use "ifconfig -a"


