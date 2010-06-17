Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111Ab0FQELI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 00:11:08 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3632 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab0FQELG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 00:11:06 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Michael Chan" <mchan@broadcom.com>
To: "'Paul Mundt'" <lethal@linux-sh.org>
cc: "'Mike Frysinger'" <vapier@gentoo.org>,
       "James Bottomley" <JBottomley@novell.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 16 Jun 2010 21:10:57 -0700
Subject: Re: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
Thread-Topic: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
Thread-Index: AcsN0i3xoVlxytTSSsmD3f/+t1jEdwAAJy0A
Message-ID: <C27F8246C663564A84BB7AB3439772421B79CBCA1D@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20100617040356.GA8105@linux-sh.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 60077FD920S160176415-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:

> On Wed, Jun 16, 2010 at 08:53:57PM -0700, Michael Chan wrote:
> > If sync_single is not defined, that means the CPU has a consistent
> > view of next_rx_buf and so it makes sense to prefetch it.
> >
> Except that's not a valid assertion, there are platforms that
> implement
> it for sanity checks yet still have consistent DMA. You are making
> inherently non-portable assumptions for a PCI driver, which is a good
> example of why drivers should never be side-stepping the API
> in the first
> place. If you want to have a micro-optimization for the consistent DMA
> case, you can check dma_is_consistent(), which is part of the API and
> will be variable on certain platform configurations (ie, some may be
> consistent with PCI but not on other busses, etc.)
>
>

Thanks for the tip.  I didn't know about the dma_is_consistent() API.
I'll use this to fix it then.

