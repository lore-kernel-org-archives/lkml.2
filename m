Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab0HBPbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:31:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44767 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab0HBPbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:31:04 -0400
Message-ID: <4C56E49E.6070102@zytor.com>
Date: Mon, 02 Aug 2010 08:30:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jeremy@goop.org,
        Ian.Campbell@citrix.com, albert_herranz@yahoo.es, x86@kernel.org,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
References: <20100728095157I.fujita.tomonori@lab.ntt.co.jp> <20100728223816.GB32739@phenom.dumpdata.com> <4C50B4C2.2070807@zytor.com> <20100729161653G.fujita.tomonori@lab.ntt.co.jp> <20100729160557.GA4403@phenom.dumpdata.com> <20100802152552.GA4732@phenom.dumpdata.com>
In-Reply-To: <20100802152552.GA4732@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 08:25 AM, Konrad Rzeszutek Wilk wrote:
> hpa, are your concerns that a) inserting a sub-system call in the
> generic code is not good. Or b) that we have five IOMMUs (counting SWIOTLB in that
> category) and that we don't jettison from memory the ones we don't need
> (that would be the primary goal of driverization of those IOMMUs,
> right?). Or c) we should remove all sub-system detect calls (Calgary, AMD,
> Intel, AGP) altogether from pci-dma.c and depend more on
> x86_init.iommu structure (perhaps expend it?)

Sorry, had to deal with other stuff.

Basically, a) and c) are the issues, with a) being the more immediate;
the amount of code left in memory is relatively small and as such I'm
not too concerned with that aspect specifically.

With five IOMMUs we're well past the point where we need to have a clean
and generic interface instead of having everything be ad hoc and
interdependent.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

