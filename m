Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1CQCZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:25:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59708 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1CQCZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:25:11 -0400
Date: Wed, 16 Mar 2011 19:25:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: mel@csn.ul.ie, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Preeti.Khurana@guavus.com
Subject: Re: rcu_sched_state detected stall on CPU issue
Message-ID: <20110317022506.GG2304@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110316101820.GA17540@linux.vnet.ibm.com>
 <20110317085938.C938.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317085938.C938.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 09:18:19AM +0900, KOSAKI Motohiro wrote:
> Hi Paul,
> 
> > Hello!
> > 
> > It looks like Preeti found a way to loop in kswapd with preemption
> > disabled, please see attached dmesg.   This is using 2.6.35-45.fc14.
> > 
> > Any thoughts or recent patches that might help?
> 
> We fixed a kswapd infinite loop issue when memory is fragmented at 2.6.38.
> Could you please try following commits? (all are mm/vmscan.c change)
> 
> commit dc83edd941f412e938841b4989be24aa288a1aa6
> commit 355b09c47a0cbb73b3e65a57c03f157f2e7ddb0b
> commit 4d40502ea580c35414a1466d86f96484910ebaec
> commit 0abdee2bd4118366c62349a304f81537be69af33
> commit 1741c87757448cedd03224f01586504f9256415d
> commit 9950474883e027e6e728cbcff25f7f2bf0c96530

Thank you, Kosaki!

> And, your attached file and your quoted mail don't have /proc/zoneinfo
> information. then I have no way to confirn his environment is heavy
> fragmented or not. If possible, could you please get /proc/zoneinfo
> info?

Preeti, could you please send this info and try out the above patches?

							Thanx, Paul
