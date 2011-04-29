Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab1D2Nme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:42:34 -0400
Received: from 8bytes.org ([88.198.83.132]:42496 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab1D2Nmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:42:33 -0400
Date: Fri, 29 Apr 2011 15:42:31 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110429134231.GI13402@8bytes.org>
References: <201104212129.17013.arnd@arndb.de> <201104281428.56780.arnd@arndb.de> <20110428131531.GK17290@n2100.arm.linux.org.uk> <201104281629.52863.arnd@arndb.de> <20110428143440.GP17290@n2100.arm.linux.org.uk> <BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 03:37:00PM -0400, Jerome Glisse wrote:
> As Jesse pointed out already, for performance reasons it's lot better
> if you let the driver decide even if you have an iommu capable of
> handling coherency for you. My understanding is that each time
> coherency is asked for it trigger bus activities of some kind (i think
> snoop is the term used for pci) this traffic can slow down both the
> cpu and the device. For graphic driver we have a lot of write once and
> use (once or more) buffer and it makes a lot of sense to have those
> buffer allocated using uncached memory so we can tell the device (in
> case of drm driver) that there is no need to trigger snoop activities
> for coherency. So i believe the decision should ultimately be in the
> driver side.

Stupid question: Couldn't these write-once-read-often buffers just stay
in the memory of the GPU instead of refetching them every time from main
memory? Or is that necessary because of the limited space on some GPUs?

Regards,

	Joerg

