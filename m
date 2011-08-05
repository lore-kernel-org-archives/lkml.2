Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab1HEXcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 19:32:53 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:27854 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752605Ab1HEXcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 19:32:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qeJNC2sVM1n6J3_N3DKKp3S7LLN5uNxnIFbJyguh03ScxPA
 67yh25U4zz_nkkgRQBsmeea7gPbHSdVKPyBmFQnPhpkITJ3r31BUBFK_IaNQ
 B8rpaEUWsxEuGMqp6zbZTVUje2fQbLsmjgWYgLLuOcF1T7HyKEYWn3S.kZaJ
 sXUM16toUMiSQ4ytxX7_BHXj1Uu0iX5byJ.19fY9u305YdumlGQ2uC46cV2I
 9wq0pa6LYU6U0q4m7WrvOyhmu9mGbyB7ZYyCVphzpFHtHZKkyPeOST52XRwy
 CCQowEkHB7B1RbmDIxuvzgbZ52uEHCWL.gSB7RAp8DkANh4zzpSOHPfdBCgn
 eNLYiB2ToNN7mi90EmMMtFzj2vby6goymA.cug2gk1glKM1lvW.xrs2zzs8A
 5OYCfw_Me5V7e6hhC3h_V9ZNJCz5soQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 5 Aug 2011 18:32:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@linux.intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [x86] Fix prefetch instruction
In-Reply-To: <4E3C5F03.8090100@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1108051831090.13276@router.home>
References: <alpine.DEB.2.00.1108051116520.28580@router.home> <4E3C4EF1.3040709@zytor.com> <alpine.DEB.2.00.1108051608110.4821@router.home> <4E3C5F03.8090100@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Aug 2011, H. Peter Anvin wrote:

> On 08/05/2011 02:10 PM, Christoph Lameter wrote:
> >>
> >> Have you done any performance analysis on this versus the null case?  I
> >> know there are some workloads where it helps, but if it hurts as many as
> >> it helps...
> >
> > No I have not. prefetch IMHO means that the cacheline is fetched early so
> > that the cacheline is fully available like any other to the code.
> > prefetchnta does fetch the cacheline too but its not treated like the other cacheline but
> > preferably thrown out again. Its a "streamfetch" designed for apps that
> > scan over large amounts of memory and want to avoid cache pollution.
> >
> > This is surprising to the end user as far as I can tell.
> >
>
> Right.  However, Linus has brought up the hypothesis that prefetch might
> actually be a net loss on x86, because current x86 processors are
> generally doing a good job with prefetching in hardware.  Directed
> prefetches can thus be a net minus.

This kinid of prefetch is a minus because the cache is evicted early. It
was prefetched with a special hint so its likely very important. That does
not seem to be very consistent and may cause regressions. Changing it to a
full prefetch would make the important cacheline stay longer in the cache.


