Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab0FAUGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:06:50 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:45051 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753044Ab0FAUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:06:47 -0400
Message-ID: <4C056854.3@athenacr.com>
Date: Tue, 01 Jun 2010 16:06:44 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       achiang@canonical.com
Subject: Re: [2.6.35-rc1 regression] sysfs: cannot create duplicate filename
 ... XVR-600 related?
References: <19461.26166.427857.612983@pilspetsen.it.uu.se>
In-Reply-To: <19461.26166.427857.612983@pilspetsen.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 03:57 PM, Mikael Pettersson wrote:
> Booting 2.6.35-rc1 on a Sun Blade 2500 Red, I'm greeted with:
>
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x74/0x90()
> sysfs: cannot create duplicate filename '/devices/root/f0079a58/pci0003:00/0003:00:02.0/slot'
> Modules linked in:
> Call Trace:
>  [0000000000458e20] warn_slowpath_fmt+0x2c/0x3c
>  [0000000000501dac] sysfs_add_one+0x74/0x90
>  [0000000000502cd4] sysfs_do_create_link+0xf0/0x184
>  [000000000055a62c] pci_create_sysfs_dev_files+0x304/0x428
>  [000000000074c6f8] pci_sysfs_init+0x20/0x6c
>  [0000000000426acc] do_one_initcall+0x44/0x164
>  [000000000073a32c] kernel_init+0x1a0/0x238
>  [000000000042aea4] kernel_thread+0x30/0x48
>  [0000000000640efc] rest_init+0x18/0x88
> ---[ end trace 8093a3146373dac8 ]---

I've seen this too on KVM; this commit caused it:

commit 75568f8094eb0333e9c2109b23cbc8b82d318a3c
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Mar 8 10:24:29 2010 -0700

    PCI: create function symlinks in /sys/bus/pci/slots/N/
    
    Create convenience symlinks in sysfs, linking slots to device
    functions, and vice versa. These links make it easier for users to
    figure out which devices actually live in what slots.

Some discussion happened at http://lkml.org/lkml/2010/4/12/259.
Alex Chiang is working on resolving this AFAIK, adding him.
