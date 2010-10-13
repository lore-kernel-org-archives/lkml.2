Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab0JMQBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:01:03 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:43029 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750963Ab0JMQBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:01:01 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _gD_07cVM1mQw.yM2tYi9jGYCuxxpfLlTzqnJsrpIcQQAUq
 KhMIj.8GtxdJbw2BGmrsn0cHOTlIV6tKO3NAlNJEySVZEWTEHaLSR8h3Q4Q8
 foO3sCfuQ4eZgQUozodXbVmF3KMwJEGAQgYwyUnzCXsTM85ayrnbuM0kPj8i
 7DlatQ0KHvrLQwkAUQn2QS6FiOY2KtptzX1NpbcPPVu8yqqAfcCGtRo0Ld3t
 b
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 13 Oct 2010 11:00:55 -0500 (CDT)
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
In-Reply-To: <alpine.DEB.2.00.1010121234380.10165@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1010131056180.29099@router.home>
References: <1286838210.30423.128.camel@edumazet-laptop> <1286839363.30423.130.camel@edumazet-laptop> <1286859925.30423.184.camel@edumazet-laptop> <20101011230322.f0f6dd47.akpm@linux-foundation.org> <1286866699.30423.234.camel@edumazet-laptop>
 <20101012002435.f51f2c0e.akpm@linux-foundation.org> <1286869793.2732.24.camel@edumazet-laptop> <20101012005856.994bea6d.akpm@linux-foundation.org> <4CB441CB.2000708@cs.helsinki.fi> <alpine.DEB.2.00.1010120745360.31832@router.home>
 <alpine.DEB.2.00.1010121234380.10165@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, David Rientjes wrote:

> > Take the unified as a SLAB cleanup instead? Then at least we have
> > a large common code base and just differentiate through the locking
> > mechanism?
> >
>
> Will you be adding the extensive slub debugging to slab then?  It would be
> a shame to lose it because one allocator is chosen over another for
> performance reasons and then we need to recompile to debug issues as they
> arise.

Well basically we would copy SLUB to SLAB apply unification patches to
SLAB instead of SLUBB. We first have to make sure that the unified patches
have the same performance as SLAB.

It maybe much better to isolate the debug features and general bootstrap
from the particulars of the allocation strategy of either SLUB or SLAB.
That way a common code base exists and it would be easier to add different
allocation strategies.

Basically have slab.c with the basic functions and then slab_queueing.c
and slab_noqueue.c for SLAB/SLUB with the particulars of the allocation
strategy?


