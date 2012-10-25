Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668Ab2JYNrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:47:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52038 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935671Ab2JYNrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:47:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 1/2] arm: mvebu: increase atomic coherent pool size for armada 370/XP
Date: Thu, 25 Oct 2012 13:46:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, "Eran Ben-Avi" <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com> <201210251127.36960.arnd@arndb.de> <20121025134352.16a8ef81@skate>
In-Reply-To: <20121025134352.16a8ef81@skate>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210251346.41596.arnd@arndb.de>
X-Provags-ID: V02:K0:s56hGXD726yj68GJS1csfIjynH66JpU7iBcYKJEpyJ0
 vwQVjWpoVgbycML6kMsmiaYKs8WIUic8OaqBWxUr429d1rUWE5
 IvZ4zbCKNSPUv1dfAvAQS5frWhCm7oOSSEy1zhT/yzJthA9ygb
 7C53sehRPGBoXQ1Y7L+aHa7Eqjlpp48eDebOgD8h754m/oIv+e
 5o8LcVq+ZFG4d08YVOfeEd1mXaWYEdVXj+FABEbhKjC9xoGbK4
 sAPSDt7JS0DdIqOYyg7VQKWfWuVTtciEtKckZgVHc88sI7UBlC
 PhqjqUpJQJqR46DwiIvdSKUylhpWj3zvChi0X3V82CdwZZKDf+
 lUvydpz09gpend1peCDk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2012, Thomas Petazzoni wrote:
> On Thu, 25 Oct 2012 11:27:36 +0000, Arnd Bergmann wrote:
> > On Wednesday 24 October 2012, Gregory CLEMENT wrote:
> > > For Armada 370/XP we have the same problem that for the commit
> > > cb01b63, so we applied the same solution: "The default 256 KiB
> > > coherent pool may be too small for some of the Kirkwood devices, so
> > > increase it to make sure that devices will be able to allocate their
> > > buffers with GFP_ATOMIC flag"
> > > 
> > > Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > 
> > Do you know why the ATA driver needs this? I find it surprising that
> > it's necessary, so I'd like to make sure we're not just working around
> > a device driver bug here.
> 
> The sata_mv driver create dma_pool and allocate objects from them, and
> all the memory allocated for dma_pools is allocated using
> dma_alloc_coherent(), and I guess the driver is using too much of them.
> 
> Seems like the driver is too lazy and allocates everything coherent to
> avoid the hassle of doing dma_map/dma_unmap operations when needed, but
> I haven't looked in details at the driver yet to see if it would be
> possible to switch those DMA coherent allocations into non-coherent
> allocations + appropriate calls to the DMA operations.

Using coherent allocations is fine, I was wondering whether they need
to be atomic or not.

> That said, that's for sure a larger task than just enabling SATA on
> Armada 370/XP, so I would advocate to handle this problem separately.

Agreed.

	Arnd
