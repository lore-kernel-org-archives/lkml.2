Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab1GYHnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:43:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab1GYHnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:43:06 -0400
Message-ID: <4E2D1E57.1080404@redhat.com>
Date: Mon, 25 Jul 2011 10:42:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
        x86 <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] syscall calling convention, stts/clts, and xstate latency
References: <CAObL_7GCDsfXWRJgkNk7c44GNF0JhQPAH_P0WiYHK7QUX1Bcaw@mail.gmail.com> <20110724211526.GA6785@elte.hu>
In-Reply-To: <20110724211526.GA6785@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 12:15 AM, Ingo Molnar wrote:
> >  All of this makes me think that, at least on Sandy Bridge, lazy
> >  xstate saving is a bad optimization -- if the cache is being nice,
> >  save/restore is faster than twiddling the TS bit.  And the cost of
> >  the trap when TS is set blows everything else away.
>
> Interesting. Mind cooking up a delazying patch and measure it on
> native as well? KVM generally makes exceptions more expensive, so the
> effect of lazy exceptions might be less on native.

While this is true in general, kvm will trap #NM only after a host 
context switch or an exit to host userspace.  These are supposedly rare 
so you won't see them a lot, especially in a benchmark scenario with 
just one guest.

("host context switch" includes switching to the idle thread when the 
guest executes HLT, something I tried to optimize in the past but it 
proved too difficult for the gain)

-- 
error compiling committee.c: too many arguments to function

