Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1I1SNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:13:52 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:50999
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753642Ab1I1SNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:13:50 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2dK9371K103dK1521M1432N98dKzz1202hzz8275bhz32i668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LS8VY4-01-QOR-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
Date: Wed, 28 Sep 2011 20:13:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.4-030004-generic; KDE/4.7.1; x86_64; ; )
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        KVM <kvm@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <33782147.oLTY4kzH1r@chlor> <4E834EE9.70102@goop.org>
In-Reply-To: <4E834EE9.70102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <201109282013.11513.stephan.diestelhorst@amd.com>
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 September 2011 18:44:25 Jeremy Fitzhardinge wrote:
> On 09/28/2011 06:58 AM, Stephan Diestelhorst wrote:
> >> I guess it comes down to throwing myself on the efficiency of some kind
> >> of fence instruction.  I guess an lfence would be sufficient; is that
> >> any more efficient than a full mfence?
> > An lfence should not be sufficient, since that essentially is a NOP on
> > WB memory. You really want a full fence here, since the store needs to
> > be published before reading the lock with the next load.
> 
> The Intel manual reads:
> 
>     Reads cannot pass earlier LFENCE and MFENCE instructions.
>     Writes cannot pass earlier LFENCE, SFENCE, and MFENCE instructions.
>     LFENCE instructions cannot pass earlier reads.
> 
> Which I interpreted as meaning that an lfence would prevent forwarding. 
> But I guess it doesn't say "lfence instructions cannot pass earlier
> writes", which means that the lfence could logically happen before the
> write, thereby allowing forwarding?  Or should I be reading this some
> other way?

Indeed. You are reading this the right way. 

> >> Could you give me a pointer to AMD's description of the ordering rules?
> > They should be in "AMD64 Architecture Programmer's Manual Volume 2:
> > System Programming", Section 7.2 Multiprocessor Memory Access Ordering.
> >
> > http://developer.amd.com/documentation/guides/pages/default.aspx#manuals
> >
> > Let me know if you have some clarifying suggestions. We are currently
> > revising these documents...
> 
> I find the English descriptions of these kinds of things frustrating to
> read because of ambiguities in the precise meaning of words like "pass",
> "ahead", "behind" in these contexts.  I find the prose useful to get an
> overview, but when I have a specific question I wonder if something more
> formal would be useful.

It would be, and some have started this efort:

http://www.cl.cam.ac.uk/~pes20/weakmemory/

But I am not sure whether that particular nasty forwarding case is
captured properly in their model It is on my list of things to check.

> I guess it's implied that anything that is not prohibited by the
> ordering rules is allowed, but it wouldn't hurt to say it explicitly.
> That said, the AMD description seems clearer and more explicit than the
> Intel manual (esp since it specifically discusses the problem here).

Thanks! Glad you like it :)

Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH
Einsteinring 24
85609 Aschheim
Germany

Geschaeftsfuehrer: Alberto Bozzo;
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632, WEEE-Reg-Nr: DE 12919551 

