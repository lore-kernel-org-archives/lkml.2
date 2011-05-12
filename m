Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab1ELOqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:46:30 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:23708 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757875Ab1ELOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:46:28 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: wrTR_oQVM1ljQagnBuNmGDTlmMyLIgQtMFeMGBiIzE7.yY9
 k7rjk_b2_VoNqPGrfqvGpNOcZNhevV9851vAVRh.blBHHyEpeObizl5DiwWU
 B4fOHQ1391w5oHkTVdX0kjG8WoeWmLj2Lg9DtyNHeGpVeAivzz2C0tB2Alql
 HZ58j8SM7wG2bVOUo2O4hzBl.LmyzRzxzA7uMYYNYGTN.AQ2EDMVaBfsaF54
 9YdEg9rkYHd9kuXdBcX1hkALLjmtyG6CM.RrTnaJkzWu30.S1ZPIPCSdR2du
 KQnV_U9H1Jd6mMJGq8u6oSgY8mBZiEOdQHpyNVuR54mfnuIePjNP9LGbIGRP
 D6EJ.SHQS4GCzajgdSpCsI1in
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 12 May 2011 09:46:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] slub: Per object NUMA support
In-Reply-To: <alpine.DEB.2.00.1105111407530.9346@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105120944480.24560@router.home>
References: <alpine.DEB.2.00.1104151449370.12627@router.home> <alpine.DEB.2.00.1105111407530.9346@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011, David Rientjes wrote:

> > Anyways the implementation is rather simple.
> >
>
> The implementation may be simple, but it seems like this would absolutely
> kill performance for MPOL_INTERLEAVE if slub is required for every
> kmalloc() or kmem_cache_alloc() to take the alternate slab node's
> list_lock to scan the partial list or, worse yet, allocate a new slab on
> that node when there are objects available on the freelist.

Right. SLAB does something similar though. We could optimize it more by
taking locks like done there and aovid the switching of the per cpu slabs.

> That, to me, would always nullify the performance benefit of using the
> mempolicy in the first place and end up making MPOL_INTERLEAVE worse than
> no mempolicy.  Do you have any benchmarks that suggest this has no
> negative impact?  I'd be very surprised.

The default is no memory policy. You would only use MPOL_INTERLEAVE on
large NUMA system that incur sufficient cross node latency to justify the
interleave.
