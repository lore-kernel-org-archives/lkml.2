Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0FQGY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:24:59 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3939 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab0FQGY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:24:57 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Michael Chan" <mchan@broadcom.com>
To: "'davem@davemloft.net'" <davem@davemloft.net>,
       "'Paul Mundt'" <lethal@linux-sh.org>
cc: "'Mike Frysinger'" <vapier@gentoo.org>,
       "James Bottomley" <JBottomley@novell.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 16 Jun 2010 23:24:44 -0700
Subject: Re: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
Thread-Topic: bnx2 fails to compile on parisc because of missing
 get_dma_ops()
Thread-Index: AcsN0i3xoVlxytTSSsmD3f/+t1jEdwAAJy0AAAaSq7A=
Message-ID: <C27F8246C663564A84BB7AB3439772421B79CBCA1E@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <C27F8246C663564A84BB7AB3439772421B79CBCA1D@IRVEXCHCCR01.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 60076027100286353-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Chan wrote:
>
> Paul Mundt wrote:
>
> > If you want to have a micro-optimization for the consistent DMA
> > case, you can check dma_is_consistent(), which is part of the API and
> > will be variable on certain platform configurations (ie, some may be
> > consistent with PCI but not on other busses, etc.)
> >
> >
>
> Thanks for the tip.  I didn't know about the dma_is_consistent() API.
> I'll use this to fix it then.
>

David, why is dma_is_consistent() always returning 1 on sparc?  The
streaming DMA is not consistent.

