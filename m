Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab1LRHbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 02:31:50 -0500
Received: from mail4.comsite.net ([205.238.176.238]:28974 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1LRHbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 02:31:47 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix order_base_2(0)
In-Reply-To: <24657.1323909224@redhat.com>
References: <24657.1323909224@redhat.com>
 <CA+55aFxEszjub9-MJD0irFs8y3hzGe3Ph=7RqWfkJ-0jKFtCeA@mail.gmail.com>
 <20111214114016.9441.12006.stgit@warthog.procyon.org.uk>
Date: Sun, 18 Dec 2011 01:15:31 -0600
X-Originating-IP: 71.22.127.106
Message-ID: <1324192531_10095@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells wrote:
> Linus Torvalds <torvalds@xxxxxxxxxxxxxxxxxxxx> wrote:
> 
> > Does anybody actually *want* order_base_2(0)?
> 
> There aren't actually that many users:
..
 
> | arch/powerpc/platforms/pseries/iommu.c: len = order_base_2(max_addr);
> 
> Not sure. Doesn't look likely, but can memory_hotplug_max() be 0 if hotplug
> is not supported?

arch/powerpc/include/asm/mmzone.h has the declaration or #define, and
arch/powerpc/mm/numa.c has the definiton when not defined.   All have
memblock_end_of_DRAM() as the minimum value, so it will never be 0.

(The usage is to get the number of bits needed to cover all possible
memory that could be allocated to the OS to size the iommu table).

milton
