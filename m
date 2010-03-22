Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0CVHp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:45:56 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:10066 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0CVHpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:45:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Questions about SMP bootup control
Date: Mon, 22 Mar 2010 15:45:36 +0800
Message-ID: <2234BBB33B4B2048B28E3B3ACFC9795C01B53656@CNBEEXC007.nsn-intra.net>
In-Reply-To: <87tys9dofy.fsf@basil.nowhere.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Questions about SMP bootup control
Thread-Index: AcrJb9jT/dBmxl1BSHCnN4ArtWRJ+wAIommw
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org><1269155601-18247-7-git-send-email-yinghai@kernel.org><1269225435.8599.70.camel@pasglop><2234BBB33B4B2048B28E3B3ACFC9795C01B53251@CNBEEXC007.nsn-intra.net> <87tys9dofy.fsf@basil.nowhere.org>
From: "Zhu, Yijun (NSN - CN/Beijing)" <yijun.zhu@nsn.com>
To: "ext Andi Kleen" <andi@firstfloor.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
X-OriginalArrivalTime: 22 Mar 2010 07:45:46.0839 (UTC) FILETIME=[AF173670:01CAC993]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: ext Andi Kleen [mailto:andi@firstfloor.org] 
Sent: Monday, March 22, 2010 11:29 AM
To: Zhu, Yijun (NSN - CN/Beijing)
Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org
Subject: Re: Questions about SMP bootup control

"Zhu, Yijun (NSN - CN/Beijing)" <yijun.zhu@nsn.com> writes:

> Hi All:
>
> I want to do some modification on the SMP architecture.
>
> Purpose:
> Only the first CPU is running the linux OS, while others do some
private
> services processing.
>
> My solution:
> In the end of the start_secondary() function, I try to schedu the
slave
> cpu to call my private endless loop instead of cpu_idle();
>
> Result:
> The system can NOT up, there is no interactive cli.
>
> Question:
> Is there some wrong with my modification or I go to the wrong way?


> Presumably you're doing this to own that CPU exclusively.
> 
> Hooking at cpu_idle is not very useful then because interrupts will be
> already enabled and the system participate in IPIs etc, so you can't
> simply disable them, the others will miss them.
> 
> You would rather need to prevent them from being started in the
> first place, e.g. by exluding them with maxcpus=..
> 
> A better alternative might be to use isolcpus=... and schedule
> a standard program.
> 
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.

Thank you very much. But when I try to apply with the isolcpus opinion,
It seems it still can NOT work.
All other CPUs are isolated, only the first one is left.
Then I found all others are still initialized by the start_secondary()
even I use the isolated opinion, in the end,
I add an endless loop instead of cpu_idle(), The system still can NOT
up.

So is there any mistake in what I did, could someone be kindness to give
me more suggestions.

Thanks in advance.



