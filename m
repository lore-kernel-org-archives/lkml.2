Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab1EMFLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 01:11:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36385 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab1EMFLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 01:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bXHOEjSd2/cnST07jfoyvBaLdg9JiU3o73DVoqO3N781MRHaetoFfqXNYozDIqy5Bh
         DzkOwTCPZcgFIxkMc0tjcFpQBarycHQIOKsefcUYAVxvbQMgmcV7q+FNxY1IGc2lkLKI
         dBp0geP810gy09B0sS0++YypB2XgSZLBkQ89g=
Subject: Re: [PATCH net-next V3] net: af_packet: Untangle packet_snd by
 adding vpacket_snd
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
In-Reply-To: <b174c9df4b7c39b4e951f1f309a4fd9086179c3c.1305242549.git.joe@perches.com>
References: <20110512.175959.1343349350164758016.davem@davemloft.net>
	 <b174c9df4b7c39b4e951f1f309a4fd9086179c3c.1305242549.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 07:11:02 +0200
Message-ID: <1305263462.2831.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 12 mai 2011 à 16:25 -0700, Joe Perches a écrit :
> The current packet_snd handles both vlan and non-vlan frames
> with initialization of a struct virtio_net_hdr that is unused
> by non-vlan frames.
> 
> Create a new vpacket_snd that uses this virtio_net_hdr and
> remove it and the vlan and gso logic from packet_snd.
> 

1) I find this kind of patches a real pain, frankly.

When I have to look around code and commits to find bugs and bugs
origins, I'll have to fully check this kind of patch, and this slow down
the process a _lot_, because I have no idea if "Joe Perches" actually
tested the patch, or if its yet another "code beautifier" process in the
wild.

You should have shooted when/before commit bfd5f4a3 (packet: Add
GSO/csum offload support) was accepted.

2) You did not CCed Sridhar Samudrala <sri@us.ibm.com>, the author of
above commit. I dont think David will take the time to test your patch.

3) You add some non codingstyle artifacts. I am afraid it makes me
nervous for patches bringing no real values but shuffling the code and
making maintainers life more difficult.




