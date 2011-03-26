Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1CZTbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:31:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753431Ab1CZTbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103261406420.24195@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger> <20110324142146.GA11682@elte.hu>
 <alpine.DEB.2.00.1103240940570.32226@router.home> <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
 <20110324172653.GA28507@elte.hu> <20110324185258.GA28370@elte.hu>
 <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>
 <20110324192247.GA5477@elte.hu> <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>
 <20110326112725.GA28612@elte.hu> <20110326114736.GA8251@elte.hu>
 <1301161507.2979.105.camel@edumazet-laptop> <alpine.DEB.2.00.1103261406420.24195@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Mar 2011 12:30:36 -0700
Message-ID: <AANLkTin8jHz0a5oS4LWQCrYW2VDb9A0V2aL7O5dYaPBt@mail.gmail.com>
Subject: Re: [PATCH] slub: Disable the lockless allocator
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 12:18 PM, Christoph Lameter <cl@linux.com> wrote:
>
> Right. RSI should be in the range of the values you printed.
> However, the determination RSI is independent of the emulation of the
> instruction. If RSI is set wrong then we should see these failures on
> machines that do not do the instruction emulation. A kvm run with Ingo's
> config should show the same issues. Will do that now.

I bet it's timing-dependent and/or dependent on some code layout
issue. Why else would the totally pointless previous patch have made
any difference for Ingo (the "SLUB: Write to per cpu data when
allocating it" thing seems to be pure voodoo programming)?

That said, this early in the boot I don't think we should have any
parallelism going on, so I don't see what could make those kinds of
random effects.

                             Linus
