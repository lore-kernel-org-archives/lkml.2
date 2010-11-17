Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139Ab0KQJLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 04:11:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635Ab0KQJLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 04:11:22 -0500
Message-ID: <4CE39C18.3010300@redhat.com>
Date: Wed, 17 Nov 2010 11:10:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <JBeulich@novell.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Eric Dumazet <dada1@cosmosbay.com>, xiyou.wangcong@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com><cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com> <4CE3A1060200007800022B04@vpn.id2.novell.com> <4CE397C8.9040901@goop.org> <4CE3992E.2070406@redhat.com> <4CE39AD2.9080606@goop.org>
In-Reply-To: <4CE39AD2.9080606@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 11:05 AM, Jeremy Fitzhardinge wrote:
> On 11/17/2010 12:58 AM, Avi Kivity wrote:
> >>  Actually in this case I'm pretty sure there's already a "set bit"
> >>  function which will do the job.  set_bit(), I guess, though it takes a
> >>  bit number rather than a mask...
> >>
> >
> >
> >  set_bit() operates on a long, while the intel manuals recommend
> >  against operating on operands of different size, especially with
> >  locked operations.  I think newer processors have more relaxed
> >  requirements, though.
>
> Despite its prototype, set_bit() is pretty specifically using "orb" for
> a the constant case, or bts otherwise (I don't know what size memory
> operation bts is considered to generate).
>

Perhaps that should be fixed.

bts will take its size from the argument, so it will be a btsq on 
x86_64.  AFAICT, the only visible difference between btsl and btsq is a 
page fault if the last four bytes of the operand are in an unmapped page.

-- 
error compiling committee.c: too many arguments to function

