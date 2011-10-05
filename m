Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934823Ab1JEPDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:03:10 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:34708 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757822Ab1JEPDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:03:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0QhOteQVM1mv3luAZbxLkYp5SwQk8QblZwNhshbSi.Kl5H5
 tj1II0o.HnPTNFraqG2zq7GMIdwVndvH7P.zbPby_Mq3wXwA4tBmSvM7cykj
 7c7LWrjstfQ4e2BSeZeG7l48A_gP8lBm5W09t54s4TKAfwIyfzdkS3pxE2BR
 WM57Dz6xgjaKXV7RTv0nzlJ67ASJBFwqokxQbRPfG.DClWT9rydjBtmLmCaI
 PsbG8OC_ucN7hhdLF1crajRlbDGwf2q5ZKxm8ZdcWS8ft7dqdbwdTWx2yCvX
 TftDjCBsQdtxNx9Ur_fNh85mzf7.Q2ngblmNBlwY_GjfRUNbwIYXlTDyF3H9
 78xFl0cgiK89uBNTlO5Wce7HN4Lqa5lN5LH_hANLK63N9rcuT4jYdlHRoYYI
 sReLQeo9nh3PEvGvT9goy3No-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 5 Oct 2011 09:26:24 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: starlight@binnacle.cx, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>
Subject: Re: big picture UDP/IP performance question re 2.6.18  -> 2.6.32
In-Reply-To: <1317820942.6766.26.camel@twins>
Message-ID: <alpine.DEB.2.00.1110050915160.30467@router.home>
References: <6.2.5.6.2.20111003112108.03a83a28@binnacle.cx>  <alpine.DEB.2.00.1110041358500.12199@router.home> <1317820942.6766.26.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Peter Zijlstra wrote:

> Clearly none of the tests being ran on a regular basis, by for instance
> the Intel regression team, covers your needs. Start by fixing that.

The most commonly run, the aged old tests contained in the AIM9 suite,
have consistently shown these regressions over long years and they have
been brought up repeatedly in numerous discussions. This is pervasive
thoughout the OS hotpaths. Just look at how the page fault latencies
change over time. Take a modern machine and then run successively older
kernel versions on it. You will see performance getting better and
latencies becoming smaller.

> Also, for latency, we've got ftrace and a latencytracer, provide traces
> that illustrate your fail.

We would need a backport of both to a kernel version that works with
reasonable latencies so that we can figure out what caused these
regressions for this particular case. Disabling network and kernel
features usually gives you better performance but there are a lot of
things in the hot paths these days that can not be disabled.
