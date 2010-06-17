Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028Ab0FQNas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 09:30:48 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4971 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759762Ab0FQNaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 09:30:46 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Michael Chan" <mchan@broadcom.com>
To: "'James Bottomley'" <JBottomley@Novell.com>
cc: "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
       "vapier@gentoo.org" <vapier@gentoo.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Jun 2010 06:30:39 -0700
Subject: Re: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
Thread-Topic: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
Thread-Index: AcsOHr+3s97ddtjaTZyzd41c178CUQAAStYA
Message-ID: <C27F8246C663564A84BB7AB3439772421B79CBCA21@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <1276780336.2789.6.camel@mulgrave.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 6004FC0A3KC6829834-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:

> On Thu, 2010-06-17 at 05:54 -0700, Michael Chan wrote:
> > This prefetch improves performance noticeably when the driver is
> > handling incoming 64-byte packets at a sustained rate.
>
> So why not do it unconditionally?  The worst that can happen
> is that you
> pull in a stale cache line which will get cleaned in the
> dma_sync, thus
> slightly degrading performance on incoherent architectures.

The original patch was an unconditional prefetch.  There was
some discussion that it might not be correct if the DMA wasn't
sync'ed yet on some archs.  If the concensus is that it is ok to
do so, that would be the simplest solution.

>
> Alternatively, come up with a dma prefetch infrastructure ...
> all you're
> really doing is hinting to the architecture that you'll sync
> this region
> next.
>
> James
>
>
>
>

