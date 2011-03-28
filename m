Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1C1Xiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:38:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51096 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1C1Xiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pz/v2gno4ZFJQXHhIbFkGxk3soOyt1i6p+05pOqmlDb5WNNaCBmbyybEHuaYLDfDel
         vm8jl/Dg889+z9idLx3K7cn29KHKHUVmbtlWC3vCSS4jHMcT6/Kzs6MPdjypNf3X8noI
         tEz7id8oFr8mKE5+Yk/gHWuGCU1UD4EmjXXfU=
MIME-Version: 1.0
In-Reply-To: <20110328231818.2297408f@lxorguk.ukuu.org.uk>
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
	<AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
	<20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
	<20110328180655.GI2287@linux.vnet.ibm.com>
	<AANLkTin6kg84P50RHR7h6NG+P_nJK=N_Nefc1q4NxzY_@mail.gmail.com>
	<20110328231818.2297408f@lxorguk.ukuu.org.uk>
Date: Tue, 29 Mar 2011 00:38:49 +0100
Message-ID: <AANLkTimXztH_4f1=7-Ez6j-7UESroqwBvVuDNW7Fmewb@mail.gmail.com>
Subject: Re: advice sought: practicality of SMP cache coherency implemented in
 assembler (and a hardware detect line)
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paulmck@linux.vnet.ibm.com, Will Newton <will.newton@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 11:18 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>  ok - well, having thought about this a little bit (in a non-detailed
>> high-level way) i was sort-of hoping, as alan hinted at, to still do
>> SMP, even if it's slow, for userspace.   the primary thing to prevent
>> from happening is to have kernelspace data structures from
>> conflicting.
>>
>>  i found kerrigan, btw, spoke to the people on it: louis agreed that
>> the whole idea was mad as hell and was therefore actually very
>> interesting to attempt :)
>>
>>  as a first approximation i'm absolutely happy for existing pthreads
>> applications to be forced to run on the same core.
>
> The underlying problem across a cluster of nodes can be handled
> transparently. MOSIX solved that problem a very long time ago using DSM
> (distributed shared memory). It's not pretty, it requires a lot of tuning
> to make it fly but they did it over comparatively slow interconnects.

 hmmm, the question is, therefore: would the MOSIX DSM solution be
preferable, which i presume assumes that memory cannot be shared at
all, to a situation where you *could* at least get cache coherency in
userspace, if you're happy to tolerate a software interrupt handler
flushing the cache line manually?

 it had occurred to me, btw, that it would be good to have separate
interrupts for userspace and kernelspace.  kernelspace would have a
"serious problem occurred!" interrupt handler and userspace would have
the horribly-slow-but-tolerable cache-flush assembly code.

 is that preferable over - faster than - the MOSIX DSM solution, do you think?

 l.

 p.s. alan am not ignoring what you wrote, it's just that if this goes
ahead, it has to be done _quickly_ and without requiring
re-verification of large VHDL macro blocks.  of the two companies
whose cores are under consideration, neither of them have done SMP
variants (yet) and we haven't got the time to wait around whilst they
get it done.  so these beautiful and hilarious hacks, which can be
tacked onto the outside, are what we have to live with for at least oo
18 months, get a successful saleable core out, that pays for the work
to be done proppa :)
