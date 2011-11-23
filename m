Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1KWPRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:17:19 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:46364 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756506Ab1KWPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:17:17 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: soUKeCcVM1kTWo5RgaW.91a6ZV2Oeg2q.BlYoOGukGo5R2o
 2nFQ_BrFGUtHgidkTdLbSp.mN63exUyCqPIBNwHpVu.goyUDHKoF.gGmpd6R
 zfPeJ2XxJH1RSKPM.ZwSgzXpnEQ.AbN0Z0GoD1P9xWPE0uUKi_JvyKPiGroU
 Zvp2jeanE9_71WCHBs4jT1.aac3Pqwc.gD2HW09Fdo_zeGKDaJwvBwkXJepZ
 79FQ7Aqx.kAyNgC2UqLaAAyGYMTYLIa.OGuaJcJ77AlzlkOmlgqy4HH9EUj8
 iFrjEsaadpb0I7qQfRn0UBIeG2mzx_WyG0VTk55MqRDVfaJKVH1jsOhhFX7W
 mn417Wj78wx8LKCwRvdBTr4CDg3yiYEMTfhdYokZLzsJ7fg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 23 Nov 2011 09:17:14 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christian Kujau <lists@nerdbynature.de>, markus@trippelsdorf.de,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH V2] slub: avoid potential NULL dereference or
 corruption
In-Reply-To: <alpine.LFD.2.02.1111231030370.14209@tux.localdomain>
Message-ID: <alpine.DEB.2.00.1111230916220.16139@router.home>
References: <1321973629.2474.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1111220855460.25785@router.home> <1321974122.2474.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LFD.2.02.1111231030370.14209@tux.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Pekka Enberg wrote:

> On Tue, 22 Nov 2011, Eric Dumazet wrote:
> > show_slab_objects() can trigger NULL dereferences or memory corruption.
> >
> > Another cpu can change its c->page to NULL or c->node to NUMA_NO_NODE
> > while we use them.
> >
> > Use ACCESS_ONCE(c->page) and ACCESS_ONCE(c->node) to make sure this
> > cannot happen.
> >
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>
> Did someone test this patch? Does it fix any of the reported issues?

It does not fix any current issues but it is safe against potential
compiler refetching of variables that we have already checked against
bad values.

I thought I acked it already?

