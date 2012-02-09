Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab2BIPAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:00:03 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:52716 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757809Ab2BIPAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:00:01 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [RFC][PATCH 00/50] set addr_assign_type to NET_ADDR_RANDOM if  a random mac address get assigned to a netdevice
Date: Thu, 9 Feb 2012 15:59:05 +0100
User-Agent: KMail/1.9.10
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de> <20120208145823.75f386c5@nehalam.linuxnetplumber.net>
In-Reply-To: <20120208145823.75f386c5@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202091559.06480.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328799601;8780de48;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 8. Februar 2012, Stephen Hemminger wrote:
> On Wed,  8 Feb 2012 22:10:07 +0100
>
> Danny Kukawka <danny.kukawka@bisect.de> wrote:
> > The information if a device has a random MAC address is exported
> > to the userspace via /sys/class/net/*/addr_assign_type, which
> > export net_device->addr_assign_type.
> >
> > Currently only a few driver really use dev_hw_addr_random() to
> > set addr_assign_type correctly to NET_ADDR_RANDOM.
> >
> > This patch change the drivers which set random addresses to
> > change also addr_assign_type to NET_ADDR_RANDOM.
> >
> > To reflect if the MAC was changed from userspace via SIOCSIFHWADDR,
> > which means it's no longer a random address set by the kernel,
> > this patch remove NET_ADDR_RANDOM from addr_assign_type in this
> > case.
> >
> > With this patch tools from userspace can now detect devices with
> > random MAC addresses and change them to persistent addresses if
> > needed (as e.g. in case of smsc95xx on PandaBoard).
> >
> > Maybe it makes sense to introduce a new state for addr_assign_type
> > to reflect the fact, that the MAC address was changed via a ioctl
> > from user space, e.g, with NET_ADDR_USERSPACE ?
>
> This reminds me that passing dev->dev_addr to dev_hw_addr_rrandom is
> redundant for all the instances you showed, so why is it ia parameter.

There are two places in the existing code where it's used in a different way 
in ixgbevf and igbvf, but thats changeable. I will take a look at it and 
change dev_hw_addr_random to take simply a net_device ands set everything 
directly.

> Also it should BUG() if address length is not 6 (ETH_ALEN).

Not needed if I change it to: 
static inline void dev_hw_addr_random(struct net_device *dev) 

Danny
