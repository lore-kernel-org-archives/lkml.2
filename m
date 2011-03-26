Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1CZTS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:18:26 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:32819 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752827Ab1CZTSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:18:25 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: JrmR10oVM1n_PvLSMtvWvhZ8T_y0kbOyxTst79753NAqRfT
 Qp82A6xilsgPvMPCUTcpwiMaG2Os8jpy_3jmmelUC_JDO9Zg2jN_8gORvsa2
 zgf1Iwe6Lm8yTQnff4_zoJ4QtZftF7r.iNMVcPlOtedqcx1_c8vjI49l4rCz
 22mTeO2Bko.erAHbjMfMxcOzEbPbkm6BW_e2BM2zO1mwnTiCItN3Exvo549u
 xETKNIF0vKYy.R.5i5QjzdUxepe8MQC7.wRMqAlt1BPuweXxHz7F__S0cNIK
 y8G8DpxVls1JKIjcaPx6g2a7p2BCFPaG2zs0E3vTWpziBh0ke
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 26 Mar 2011 14:18:20 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: Disable the lockless allocator
In-Reply-To: <1301161507.2979.105.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1103261406420.24195@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>  <20110324142146.GA11682@elte.hu>  <alpine.DEB.2.00.1103240940570.32226@router.home>  <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>  <20110324172653.GA28507@elte.hu> <20110324185258.GA28370@elte.hu>
  <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>  <20110324192247.GA5477@elte.hu>  <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>  <20110326112725.GA28612@elte.hu>  <20110326114736.GA8251@elte.hu>
 <1301161507.2979.105.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Mar 2011, Eric Dumazet wrote:

> address : RSI = ffff88003ffc2020
>
> RSI is supposed to be a dynamic percpu addr
> Yet this value seems pretty outside of pcpu pools
>
> CR2: ffff87ffc1fdd020

Right. RSI should be in the range of the values you printed.
However, the determination RSI is independent of the emulation of the
instruction. If RSI is set wrong then we should see these failures on
machines that do not do the instruction emulation. A kvm run with Ingo's
config should show the same issues. Will do that now.


