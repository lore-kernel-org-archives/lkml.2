Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1LLSxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:53:48 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:21635 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753184Ab1LLSxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:53:47 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VzCCgXIVM1mWvsEaYhEjorhKgLpA6Q2bx2g7PJEH.ekdCEw
 mbjXSb7hlWot491..tFeFI_2ba5HJo3dRRT1WA4V0apariuYjI75DCR4DRVJ
 80z2w__J6AL4RXWgOOkg94_19ATfXWLcqz1g_2TwjyZfcbLMjjquZRfmHsEM
 BK07PdJO.cHMByY8lv1vigvAYXsH3RgaUH5PuaF3ovkjhZ2BC276hKRLyd9I
 GdRRaF.F1_dINMxLCQxQ7FChqBnX_DK3O_wSrOB1y12RZXD.J2tVanGO3D4w
 mKf8204h.9W3SkMybK6WivboHpi2si9Bjh5YY68J0_Z.j8pFyI_FmDeoTR25
 sHxHrgPo51FsEn3193n2bXw2z2C4VP3R7g0Gp7x8BxpYfeA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 12 Dec 2011 12:53:45 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: zhihua che <zhihua.che@gmail.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Slub allocator] There are chances that kmem_cache_cpu->freelist
 gets lost if the process happens to be rescheduled to a differenet cpu before
 the local_irq_save() completes in __slab_alloc()
In-Reply-To: <1323711558.2583.11.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1112121252430.31975@router.home>
References: <CABexPfFR1n=_JdCYLDRcVsPRcqt5FGmhSjoeZP8CLBMRO_CxfA@mail.gmail.com>  <1323702586.1765.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1112120922020.28410@router.home> <1323711558.2583.11.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, Eric Dumazet wrote:

> Indeed, I reproduced the leak with hackbench and lot of threads.

Ran it here and did not see anything. But obviously this is an issue.
Strange that no one noticed earlier. Usage of CONFIG_PREEMPT must not be
that frequent.

