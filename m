Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0JMVnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 17:43:42 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:44630 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752007Ab0JMVnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 17:43:41 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: DAfkfyYVM1lr0BoP6qXxv99rPwCrXyM_EEhuTMQq7CMdQ9T
 ZJS9BRFlsA3xOXm7PDFLP17640Dpt2RMF7_oNHN64gGtY71jpNGw.c547BZr
 N9DOXTGNjlwIS4eJy78E6pdS19qqRAfJ5vlZOeZKZTYu6dpd4g.rmqsGlsEG
 wLxk1egRWECUP_kHER6S4RMHoAxYYbLOYXdw9jwTn5k3wsSnYfyDSdRV0SKY
 4BG3WnCzjk2Phm4ic_mjx9T58jmV1
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 13 Oct 2010 16:43:36 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH net-next] net:  allocate skbs on local node
In-Reply-To: <alpine.DEB.2.00.1010131342310.15185@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1010131642220.8351@router.home>
References: <1286838210.30423.128.camel@edumazet-laptop> <1286839363.30423.130.camel@edumazet-laptop> <1286859925.30423.184.camel@edumazet-laptop> <20101011230322.f0f6dd47.akpm@linux-foundation.org> <1286866699.30423.234.camel@edumazet-laptop>
 <20101012002435.f51f2c0e.akpm@linux-foundation.org> <1286869793.2732.24.camel@edumazet-laptop> <20101012005856.994bea6d.akpm@linux-foundation.org> <4CB441CB.2000708@cs.helsinki.fi> <alpine.DEB.2.00.1010120745360.31832@router.home>
 <alpine.DEB.2.00.1010121234380.10165@chino.kir.corp.google.com> <alpine.DEB.2.00.1010131056180.29099@router.home> <alpine.DEB.2.00.1010131342310.15185@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010, David Rientjes wrote:

> > Basically have slab.c with the basic functions and then slab_queueing.c
> > and slab_noqueue.c for SLAB/SLUB with the particulars of the allocation
> > strategy?
> >
>
> I was going to mention that as an idea, but I thought storing the metadata
> for certain debugging features might differ from the two allocators so
> substantially that it would be even more convoluted and difficult to
> maintain?

We could have some callbacks to store allocator specific metadata?

