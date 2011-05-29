Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1E2AMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 20:12:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:38325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab1E2AMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 20:12:20 -0400
Subject: Re: [PATCH 0/7] Intel pci: Fix various problems with Intel IOMMU
 code
From: David Woodhouse <dwmw2@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Habeck <habeck@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Derek Fults <dfults@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 29 May 2011 01:12:02 +0100
In-Reply-To: <20110528181501.896092225@gulag1.americas.sgi.com>
References: <20110528181501.896092225@gulag1.americas.sgi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306627925.2029.341.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 13:15 -0500, Mike Travis wrote:
> 	Various problems exist in the Intel IOMMU PCI driver when
> 	using DMA remapping in 1:1 identity mode on UV systems and
> 	devices cannot address all of physical memory.
> 
> 	This patchset addresses those problems.

Patches 1-6 applied to iommu-2.6.git. Please test. Thanks.

Please note for future reference that 'From:' lines such as the one in
your patch 1/7 should be *first* in the body of your email. The git-am
tool doesn't find them and set the authorship if you put them with the
Signed-off-bys. Also please avoid putting whitespace at the beginning of
every line of your commit comments.

I still hate patch 7, but the point was that I wouldn't have to care
about it. Once your patches 1-6 are included in known stable releases
that your SCU can recognise, it can just pass 'iommu=pt' for those.

It's only the "probably buggy" kernels with older release numbers that
you'll pass 'forcedac,pt64' to, so your mission is to get patch 7 or
some variant of it accepted into *those* kernels.

-- 
dwmw2

