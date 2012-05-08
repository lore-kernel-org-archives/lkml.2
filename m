Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab2EHRUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:20:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab2EHRUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:20:39 -0400
Date: Tue, 8 May 2012 19:57:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply 5/5] kvm_para: guest side for eoi avoidance
Message-ID: <20120508165736.GA26795@redhat.com>
References: <cover.1334833140.git.mst@redhat.com>
 <5e1399d9e743668a87f31d8f2b83cad862c60728.1334833141.git.mst@redhat.com>
 <4FA93B3F.3000906@redhat.com>
 <20120508152843.GE8988@redhat.com>
 <4FA93FA3.20306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA93FA3.20306@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 08:45:39AM -0700, H. Peter Anvin wrote:
> On 05/08/2012 08:28 AM, Gleb Natapov wrote:
> > On Tue, May 08, 2012 at 05:26:55PM +0200, Paolo Bonzini wrote:
> >> Il 23/04/2012 16:04, Michael S. Tsirkin ha scritto:
> >>> +/* Our own copy of __test_and_clear_bit to make sure
> >>> + * it is done with a single instruction */
> >>
> >> Is this for microoptimization or correctness?  If the latter, it does
> >> not ensure anything without a "lock" prefix.
> >>
> > It can't race with other vcpus, only with vmexit on the same vcpu.
> > 
> 
> That doesn't answer the question very well... I really don't understand
> the point of having a private copy here.
> 
> I really, really don't want a bunch of private interfaces around.  It
> would be a lot better to define a test_and_{set,clear}_bit_local() in
> <asm/bitops.h> which is defined to be local CPU atomic.
> 
> 	-hpa

Will do. OK to only define them for x86 for now?
They would be unused on other arches even if I defined them ...

> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
