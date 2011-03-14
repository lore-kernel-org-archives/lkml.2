Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab1CNTYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:24:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab1CNTYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:24:48 -0400
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=JmPYChc5JtYA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3vXW2efjfCzugMQovxwA:9 a=zh-d5kGcDP9u90gcqBcWE3RN1N0A:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 14 Mar 2011 15:24:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <JBeulich@novell.com>, sedat.dilek@gmail.com,
        Alan Modra <amodra@bigpond.net.au>, Ingo Molnar <mingo@elte.hu>,
        "H.J. Lu" <hjl.tools@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: Add --size-check=[error|warning]
Message-ID: <20110314192445.GD20259@home.goodmis.org>
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
 <4D7E095802000078000363D5@vpn.id2.novell.com>
 <4D7E4338.1060302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7E4338.1060302@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 09:32:56AM -0700, H. Peter Anvin wrote:
> On 03/14/2011 04:26 AM, Jan Beulich wrote:
> > 
> > Making the kernel build system check for certain newly introduced
> > gas options would again require changes to the kernel sources,
> > which is precisely what is impossible to do for past kernel releases
> > (and bisection in particular).
> > 
> 
> But something like "make CC='gcc -Wa,--size-check=warning'" should work,
> I believe (tweaking may be required, but that's the idea).  Passing an
> option to the assembler is a helluva lot easier than redirecting to a
> different assembler.
> 
> 	-hpa
> 

Even if the above does work, how do we go about educating users doing
bisects with latest binutils? This is a very common practice among
kernel developers with users that hit bugs. And right now there's just a
handful of people that know of this work-around.

It will become a huge burden to us and our users (which is everyone
using Linux), if we do not understand the reason a build breaks when
doing a bisect, just because some "bug" in asm which binutils use to
work with now errors on.

If it was a bug in asm, but binutils can cope with it, then it should be
a warning. If binutils can't cope, then error.

-- Steve

