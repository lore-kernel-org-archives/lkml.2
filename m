Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0KOORE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:17:04 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:40467 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755593Ab0KOORB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:17:01 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: NxOAVcMVM1nmNe.jTm75oD5xe70OwbIoRpJhhhxRt9a82rx
 DvZzFeVW23nUbTh16SB_7MCGnfdx40ntWWuBg15fQtkR8tMNZ.eyDKAlGn8l
 azA36o9i7Qww8v.YTx_m0FamtYMnx7fxRkMXiEniA7Tsj51vmRykN3NYg1N9
 db4groJd1BfGpN.t.46KRCLEX6MdFA7cPFGPcGqqo0u5kN6CHjC4KbrKKXD9
 qUzT30Nc3glU-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 15 Nov 2010 08:16:57 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH] atomic: add atomic_inc_not_zero_hint()
In-Reply-To: <20101115140739.GJ7269@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.1011150814480.19175@router.home>
References: <20101105102038.53e36f9e.akpm@linux-foundation.org> <1288980046.2882.1054.camel@edumazet-laptop> <20101105110828.52f061b3.akpm@linux-foundation.org> <1288981224.2882.1105.camel@edumazet-laptop> <20101105112821.57f80481.akpm@linux-foundation.org>
 <1288984844.2665.52.camel@edumazet-laptop> <20101105195101.GC15561@linux.vnet.ibm.com> <alpine.DEB.2.00.1011121313001.16754@router.home> <20101113222612.GD2825@linux.vnet.ibm.com> <alpine.DEB.2.00.1011150756130.19175@router.home>
 <20101115140739.GJ7269@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Andi Kleen wrote:

> > It is another way to get an exclusive cache line
> > for situations like this. No need to give a hint.
>
> prefetchw doesn't work on Intel (or rather is equivalent to prefetch),
> for Intel you always need to explicitely write to get an exclusive
> line.

Argh. You mean x86. Itanium could do it and is also by Intel. Could you
please change that for x86 as well? Otherwise we will get more of these
weird code twisters.


