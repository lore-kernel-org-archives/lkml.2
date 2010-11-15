Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0KOOZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:25:44 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:20863 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757380Ab0KOOZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:25:43 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: MiyXSQkVM1nhNr1qpqai3i..Lj29BNwEUK0D9Yhh2GQGAyB
 xSFbY.ObQoFXSYAdlRdN1.D6sOjTsXtDpoGBurzOkcfGvzBlzwyaE5bVcE8g
 dUIyWFdjY4jrkzm38VeEKNqT3Mc9Gz2Beo3WJf_yCg2K53jHSL3._XWzRy5u
 eMpl_oi.yk9fyzQZCyNejY_ksnlUlfktxfwLlA8D94CeHzUWLtds_8vQVkyY
 C.Twb1ug7YV4-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 15 Nov 2010 08:25:37 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH] atomic: add atomic_inc_not_zero_hint()
In-Reply-To: <1289830636.2607.70.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1011150821000.19175@router.home>
References: <1288975980.2882.877.camel@edumazet-laptop>  <20101105102038.53e36f9e.akpm@linux-foundation.org>  <1288980046.2882.1054.camel@edumazet-laptop>  <20101105110828.52f061b3.akpm@linux-foundation.org>  <1288981224.2882.1105.camel@edumazet-laptop> 
 <20101105112821.57f80481.akpm@linux-foundation.org>  <1288984844.2665.52.camel@edumazet-laptop>  <20101105195101.GC15561@linux.vnet.ibm.com>  <alpine.DEB.2.00.1011121313001.16754@router.home>  <20101113222612.GD2825@linux.vnet.ibm.com> 
 <alpine.DEB.2.00.1011150756130.19175@router.home> <1289830636.2607.70.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Eric Dumazet wrote:

> Exclusive access ? As soon as another cpu takes it again, you lose.

Sure but you want to avoid the fetch in shared mode here.

> Its not really the same thing... Maybe you miss the 'hint' intention at
> all. We know the probable value of the counter, we dont want to read it.

Ok may be in thise case you can predict the value but in general it is
difficult to always provide an expected value. It would be easier to be
able to tell the processor that the cacheline should not be fetched as
shared but immediately in exclusive state.

> atomic_read() and atomic_cmpxchg(). We tried prefetchw() and it was a
> performance drop. It was with only 16 cpus contending on neighbour

Does prefetchw work? Andi claims that prefetchw is not working on
x86 and I doubt that you ran tests on Itanium.
