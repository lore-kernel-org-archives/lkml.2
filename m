Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2EBJjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:39:14 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:48353 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2EBJjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:39:12 -0400
Date: Wed, 2 May 2012 11:39:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        Chris Zankel <chris@zankel.net>
Subject: Re: Build regressions/improvements in v3.4-rc5
In-Reply-To: <alpine.DEB.2.00.1205021134570.1538@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1205021135510.1572@ayla.of.borg>
References: <alpine.DEB.2.00.1205021134570.1538@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2012, Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.4-rc5[1] compared to v3.3[2].
> 
> Too make this mail fit in the lkml limit, I deleted
>   - 104 lines about __mcount_loc on sparc64
>   - all warning improvements
> 
> Summarized:
>   - build errors: +107/-82
>   - build warnings: +284/-999
> 
> JFYI, when comparing v3.4-rc5 to v3.4-rc4[3], the summaries are:
>   - build errors: +34/-2283
>   - build warnings: +145/-681

powerpc-randconfig:

  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: 'FSL_DIU_PORT_DVI' undeclared (first use in this function):  => 189:9
  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: parameter 1 ('port') has incomplete type:  => 187:54, 83:56, 88:57, 69:56
  + arch/powerpc/platforms/512x/mpc512x_shared.c: error: return type is an incomplete type:  => 187:1
  + drivers/virt/fsl_hypervisor.c: error: 'MSR_GS' undeclared (first use in this function):  => 799:80

xtensa-allnoconfig:

  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `__netif_schedule':  => .text+0x48)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `alloc_etherdev_mqs':  => .text+0x11c)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `consume_skb':  => .text+0x4c)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `dev_alloc_skb':  => .text+0x60)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `dev_close':  => .text+0x84)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `eth_type_trans':  => .text+0xac)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `eth_validate_addr':  => .rodata+0x114)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `free_netdev':  => .text+0x134)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `kfree_skb':  => .text+0x70)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `netif_rx_ni':  => .text+0x6c)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `register_netdevice':  => .text+0x12c)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `rtnl_lock':  => .text+0x128)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `rtnl_unlock':  => .text+0x130)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `skb_put':  => .text+0x64)
  + error: arch/xtensa/platforms/iss/built-in.o: undefined reference to `skb_trim':  => .text+0x68)
  + error: kernel/built-in.o: undefined reference to `_sdata':  => .text+0x8c0), .text+0x84c)
  + error: network.c: undefined reference to `__netif_schedule':  => .text+0x3d7)
  + error: network.c: undefined reference to `alloc_etherdev_mqs':  => .text+0x8c8)
  + error: network.c: undefined reference to `consume_skb':  => .text+0x42e)
  + error: network.c: undefined reference to `dev_alloc_skb':  => .text+0x4c8)
  + error: network.c: undefined reference to `dev_close':  => .text+0x683)
  + error: network.c: undefined reference to `eth_type_trans':  => .text+0x7db)
  + error: network.c: undefined reference to `free_netdev':  => .text+0xad2)
  + error: network.c: undefined reference to `kfree_skb':  => .text+0x548)
  + error: network.c: undefined reference to `netif_rx_ni':  => .text+0x53e)
  + error: network.c: undefined reference to `register_netdevice':  => .text+0xab7)
  + error: network.c: undefined reference to `rtnl_lock':  => .text+0xaaf)
  + error: network.c: undefined reference to `rtnl_unlock':  => .text+0xabf)
  + error: network.c: undefined reference to `skb_put':  => .text+0x507)
  + error: network.c: undefined reference to `skb_trim':  => .text+0x514)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
