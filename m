Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1DZPj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:39:27 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:37163 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751438Ab1DZPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:39:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LuYjlYS6EiOKMw69QemCwuSrbSJMwH/HjgPeng8ntHvDsSHCkhwfm7uMVe34x+mwPCwziOFdkDx9JI+EmT8MhXvIcaIShsV2JJlrz6EJyQIvrags6szHyOP6EQztDbYo;
Date: Tue, 26 Apr 2011 08:39:22 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110426083922.344bd8d6@jbarnes-desktop>
In-Reply-To: <201104261626.20152.arnd@arndb.de>
References: <201104212129.17013.arnd@arndb.de>
	<20110421130930.4be9e9e1@jbarnes-desktop>
	<201104261626.20152.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 16:26:19 +0200
Arnd Bergmann <arnd@arndb.de> wrote:
> I don't thing that this argument has anything to do with what the
> underlying API should be, right? I can see this built on top of either
> the dma-mapping headers with extensions to map potentially uncached
> pages, and with the iommu API. Neither way would however save us from
> implementing the three items listed above.

Or simply extending the DMA mapping API to allow for allocations
without mapping.  I was just worried you had a more traditional driver
model in mind (e.g. coherent alloc on the ring buffer, single mappings
for data buffers, all mapped in the kernel driver at allocation time).

The DMA API does have some advantages, in that arches already support
it, there's some infrastructure for handling per-bus mapping, etc., so
building on top of it is probably a good idea.

> It's certainly a good point to note that we should have a way to
> allocate pages for a device without mapping them into any address
> space right away. My feeling is still that the dma mapping API is
> the right place for this, because it is the only part of the kernel
> that has knowledge about whether a device needs uncached memory for
> coherent access, under what constraints it can map noncontiguous
> memory into its own address space, and what its addressing capabilities
> are (dma mask).

Right.  Sometimes a device or platform can handle either cached or
uncached though, and we need userspace to decide on the best type for
performance reasons.

-- 
Jesse Barnes, Intel Open Source Technology Center
