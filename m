Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1HYTTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:19:32 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:31662 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751833Ab1HYTTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:19:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: grWxXO0VM1lTuNO8xAnp4n1LqoBKkQS56KtnMvm.WiEVcX3
 53AkrhIzdjOFYtkBldwXVcLzd0h9zVsJkoOyiZCs5gEG5s.bAtXLSSLJ858a
 .nquTy4qpirRIp8oskcxe.9OeZTnCk7l3HvZwM3LeIMInOmi3Ys7Zsb0lij3
 VciB5A_Zm_ZGcjWAi6P3EwqlJGWMB5GCuRepDNGBFJJkPFPmnWyPSR6pvk6T
 vgxLt6IDeBSp3rX2ngJZGhBtupaK98pxb2MIipd_F0rLqsISbqpe2oOAgLo0
 uBJN7tix_QDeiwK6sxzjXvfcTRxtQOOHAAwC.e9skVA.bReiz_yyja7IXw8X
 MdXOaGN3hnLzagqSyT_xLit7ZPSzRaRCgkxuWMr4ipikt5Q--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 25 Aug 2011 14:19:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: James Bottomley <James.bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
In-Reply-To: <1314299115.26922.2.camel@twins>
Message-ID: <alpine.DEB.2.00.1108251413130.27407@router.home>
References: <1313650253-21794-1-git-send-email-gthelen@google.com>  <20110818144025.8e122a67.akpm@linux-foundation.org>  <1314284272.27911.32.camel@twins>  <alpine.DEB.2.00.1108251009120.27407@router.home>  <1314289208.3268.4.camel@mulgrave> 
 <alpine.DEB.2.00.1108251128460.27407@router.home>  <986ca4ed-6810-426f-b32f-5c8687e3a10b@email.android.com>  <alpine.DEB.2.00.1108251206440.27407@router.home>  <1e295500-5d1f-45dd-aa5b-3d2da2cf1a62@email.android.com>  <alpine.DEB.2.00.1108251341230.27407@router.home>
 <1314299115.26922.2.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, Peter Zijlstra wrote:

> Also, I thought this_cpu thing's were at best locally atomic. If you
> make them full blown atomic ops then even __this_cpu ops will have to be
> full atomic ops, otherwise:
>
>
> CPU0			CPU(1)
>
> this_cpu_inc(&foo);	preempt_disable();
> 			__this_cpu_inc(&foo);
> 			preempt_enable();
>
> might step on each other's toes.

They would both have their own instance of "foo". per cpu atomicity is
only one requirement of this_cpu_ops. The other is the ability to relocate
accesses relative to the current per cpu area.

Full blown atomicity is almost a superset of per cpu atomicity but its
only usable if the full atomic instructions can also relocate accesses
relative to some base.

