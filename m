Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191Ab0FQOgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:36:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53664
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760176Ab0FQOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:36:41 -0400
Date: Thu, 17 Jun 2010 07:36:53 -0700 (PDT)
Message-Id: <20100617.073653.193708702.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: mchan@broadcom.com, lethal@linux-sh.org, vapier@gentoo.org,
       JBottomley@novell.com, netdev@vger.kernel.org,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100617211946A.fujita.tomonori@lab.ntt.co.jp>
References: <C27F8246C663564A84BB7AB3439772421B79CBCA1D@IRVEXCHCCR01.corp.ad.broadcom.com>
	<C27F8246C663564A84BB7AB3439772421B79CBCA1E@IRVEXCHCCR01.corp.ad.broadcom.com>
	<20100617211946A.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 17 Jun 2010 21:21:13 +0900

> On Wed, 16 Jun 2010 23:24:44 -0700
> "Michael Chan" <mchan@broadcom.com> wrote:
> 
>> David, why is dma_is_consistent() always returning 1 on sparc?  The
>> streaming DMA is not consistent.
> 
> I think that there are some confusion about dma_is_consistent(). Some
> architectures think that dma_is_consistent() is supposed to return 1
> if they can allocate coherent memory (note that some architectures
> can't allocate coherent memory).

Right, and that's why it's defined this way.

If the desired meaning is different, just me know and I'll fix the
sparc definition.

