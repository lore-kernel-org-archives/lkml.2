Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0EaATm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 20:19:42 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64864 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0EaATl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 20:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JtIajDHFdsNJFEoFFpbnXgodCvAdILrY5c5/ZOoWzteOGeDJtxXeBAHDAP5pfSt0XH
         Q/rgOzpGABhWAXeR8msMxp1lG19YQYBYlI3rP/s+LPViQSCVqFA5HzkjpkxuoYB7t/2T
         AReL/sFE3jYO1ppmQH3iKOPo8iyzapQcNHWUE=
MIME-Version: 1.0
In-Reply-To: <AANLkTim5zUD18vmMeNSzo2o8UGg8pr8l1uPbSYmHamq8@mail.gmail.com>
References: <AANLkTim5zUD18vmMeNSzo2o8UGg8pr8l1uPbSYmHamq8@mail.gmail.com>
Date: Mon, 31 May 2010 08:19:39 +0800
Message-ID: <AANLkTikqD93owVeTLxr2n9U7qYEhqHy0Vew5mx33Eih6@mail.gmail.com>
Subject: Re: About offload function of Virtio Nic
From: Amos Kong <kongjianjun@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, davem@davemloft.net, kvm@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 7:44 AM, Amos Kong <kongjianjun@gmail.com> wrote:
> Hello all,
>
> Can I ask some question of the offloading function with Virtio-NIC?
>
> I'm interested in KVM virtualization. The virtual NIC is different
> from real hardward. And there is also a big distance between
> Virtio-NIC and E1000-NIC.
> The offloading function of Virtio-NIC close related with the function
> of host's real hardware.
> Associate Feature bits:
> VIRTIO_NET_F_GUEST_...
> VIRTIO_NET_F_HOST_...
>
> ---------------------------------------------------
> command:
> enable rx:  guest) # ethtool -K eth0
> enable tx:  guest) # ethtool -K eth0
> enable gs: guest) # ethtool -K eth0
> enable tso: guest) # ethtool -K eth0
> enable gso: guest) # ethtool -K eth0
> enable lro: guest) # ethtool -K eth0
> enable gro: guest) # ethtool -K eth0

sorry , it should be

enable rx:  guest) # ethtool -K eth0 rx on
enable tx:  guest) # ethtool -K eth0 tx on
enable gs: guest) # ethtool -K eth0 gs on
enable tso: guest) # ethtool -K eth0 tso on
enable gso: guest) # ethtool -K eth0 gso on
enable lro: guest) # ethtool -K eth0 lro on
enable gro: guest) # ethtool -K eth0 gro on

It also works with my real hardware.

> Those steps work well with Virtual E1000-NIC, but it always fail when
> using Virtio-NIC.
>
> ---------------------------------------------------
> After setup, I have two check method. For example:
> 1. enable tso
> 2. check the output of 'ethtool -k eth0'
> 3. send large file from guest to host by scp, listen by tcpdump during
> transferring file. and check if there contains some large
> packet($length > 1514).
>
> The check method works with Virtual E1000-NIC, but it always fail when
> using Virtio-NIC.
>
> ---------------------------------------------------
> My question:
> 1. How to setup offloading function of Virtio-NIC?
> 2. How about my check method of offloading function(transferring file,
> check packet length by tcpdump)?
> 3. Is there some detail user guide for Virtio-NIC?
>
>
>
> Best Regards,
> Amos
>



-- 
个人主页搬家了，欢迎来串门  ;)
http://kongove.whostas.com/
