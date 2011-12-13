Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1LMQ15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 11:27:57 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:30765 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752728Ab1LMQ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 11:27:56 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WaHlRCoVM1mejxyroLiLNZIXJk_QP0b8MyjWgER90BvOJYs
 za_32efZDxysQaFaHlHKQfmomOVZTQUzzy8iFP9qpH3EIrhhyQF5L.fBxqtp
 dQbrS8_nTK5aFWWFfKXYfzsK7YFiWL94bMy6llI.9tK0U9gEqpHDxuixobww
 3XwvAWpt16ShFtYS0D3Eta4QQjy64c9KcPf2yxk0l2eC2QAQtDXE8SImJp.Y
 zUdMnMo7_C9IH4GrvoumOViNz8XxeipU45.PWKlt7SzvifrL2NX7HIPwaL7_
 oEEtJDTf3AS2TQgH0o6QQBlckMoZwiGSgM96C2_r087PPFzFlj.74Vsyvyox
 Wt94yM.ywMYnkINrgqEqmsmeUYXgSDDpOT7CgPvHTenK5Kw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 13 Dec 2011 10:27:53 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: zhihua che <zhihua.che@gmail.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Slub allocator] There are chances that kmem_cache_cpu->freelist
 gets lost if the process happens to be rescheduled to a differenet cpu before
 the local_irq_save() completes in __slab_alloc()
In-Reply-To: <1323748626.2583.41.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1112131025370.23111@router.home>
References: <CABexPfFR1n=_JdCYLDRcVsPRcqt5FGmhSjoeZP8CLBMRO_CxfA@mail.gmail.com>  <1323702586.1765.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1112120922020.28410@router.home>  <1323711558.2583.11.camel@edumazet-laptop>
 <1323748626.2583.41.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, Eric Dumazet wrote:

> We can be interrupted and the IRQ handler can free an object an populate
> freelist too. So the check must always be done.

True. So a small memory leak that remained undetected. Hmm.... Wonder how
one can create some diagnostics to allow detection of this in the future.

Acked-by: Christoph Lameter <cl@linux.com>
