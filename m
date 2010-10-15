Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab0JOPYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:24:47 -0400
Received: from borg.medozas.de ([188.40.89.202]:39903 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025Ab0JOPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:24:46 -0400
Date: Fri, 15 Oct 2010 17:24:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andreas Gruenbacher <agruen@suse.de>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, davem@davemloft.net
Subject: Re: Process to push changes to include/linux/types.h
In-Reply-To: <201010151644.21794.agruen@suse.de>
Message-ID: <alpine.LNX.2.01.1010151713060.30823@obet.zrqbmnf.qr>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com> <201010151215.49392.agruen@suse.de> <20101015142617.GB25620@basil.fritz.box> <201010151644.21794.agruen@suse.de>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2010-10-15 16:44, Andreas Gruenbacher wrote:
>On Friday 15 October 2010 16:26:17 Andi Kleen wrote:
>> > 64-bit values align to 4-byte boundaries on some 32-bit architectures like
>> > x86 
>> AFAIK it's only on x86, no other architecture made this mistake in their
>> 32bit ABI. But of course x86 is kind of important ...
>
>I don't know of any other examples; all the architectures I tried "got it 
>right" except x86.

I don't think x86 has done anything wrong. It processes stuff in
32-bit chunks, so why should one waste space for aligning a 64-bit
entity to 8? On sparcv9, a long double also has an alignment
smaller than its size.

If you don't like that, you can always patch up gcc, because
alignment is after all a decision made by the compiler. In that
regard, it might be worth checking out the gcc machine description
files and find out why people specified an alignment of 8 for
uint64_t anything but i?86.
