Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab1HEVKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:10:53 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:48098 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752142Ab1HEVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:10:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OphciCsVM1nzFyixbJqO8ZpzZ9rxwKI15qaIkapaOZC1F3c
 DQke3AfLoCxDM0EvxGU6kgR2.qDWOmTX4GXr9DWyt0xpVWgk_EgXW3aT1gKV
 yxulC82TpIcf3YnrI.AJGYIvybsS9C0X9rbum5hb7AoT69zV9Dt4u8u5HXWi
 wfRm2GI7AO_JnpCKPnx8kP.a0.4l38RNMOLdkDWFVowPVQdzFXs0jnuOIeft
 Yw6C9AFhpi1cjtMvO5JzFpNVv95Un71m02LjJvpNr1qvHIEpMm3if6Y1jHOt
 Z9shqVKyGIYT4X6W0b7Igt2VwgsmTzAsxqajNmiDZGSgXqfOSGReojmP.KJF
 SiLRAL4.W.NmEsB54FyRmwP4lpVfbOILB8NlzaJ3Sh7E1uA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 5 Aug 2011 16:10:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [x86] Fix prefetch instruction
In-Reply-To: <4E3C4EF1.3040709@zytor.com>
Message-ID: <alpine.DEB.2.00.1108051608110.4821@router.home>
References: <alpine.DEB.2.00.1108051116520.28580@router.home> <4E3C4EF1.3040709@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Aug 2011, H. Peter Anvin wrote:

> On 08/05/2011 09:18 AM, Christoph Lameter wrote:
> > The prefetchnta instruction used for prefetching on x86 is a special instruction
> > used for streaming that is usually used to avoid polluting the l2 and l3 caches.
> > The cacheline will be evicted rapidly.
> >
> > What we need is a prefetch that puts the cacheline in all levels of the cache hierachy instead.
> > Change the instruction to do that.
> >
> > Acked-by: Andi Kleen <ak@linux.intel.com>
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> >
>
> Have you done any performance analysis on this versus the null case?  I
> know there are some workloads where it helps, but if it hurts as many as
> it helps...

No I have not. prefetch IMHO means that the cacheline is fetched early so
that the cacheline is fully available like any other to the code.
prefetchnta does fetch the cacheline too but its not treated like the other cacheline but
preferably thrown out again. Its a "streamfetch" designed for apps that
scan over large amounts of memory and want to avoid cache pollution.

This is surprising to the end user as far as I can tell.

