Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab1IBT3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:29:42 -0400
Received: from claw.goop.org ([74.207.240.146]:45069 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab1IBT3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:29:40 -0400
Message-ID: <4E612EA1.20007@goop.org>
Date: Fri, 02 Sep 2011 12:29:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>  <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com> <1314974826.1861.1.camel@twins>
In-Reply-To: <1314974826.1861.1.camel@twins>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 07:47 AM, Peter Zijlstra wrote:
> On Thu, 2011-09-01 at 17:55 -0700, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> We need to make sure interrupts are disabled while we're relying on the
>> contents of the per-cpu lock_waiting values, otherwise an interrupt
>> handler could come in, try to take some other lock, block, and overwrite
>> our values.
> Would this make it illegal to take a spinlock from NMI context?

That would be problematic.  But a Xen domain wouldn't be getting NMIs -
at least not standard x86 ones - so that's moot.

> I know that its generally considered bad form, but there's at least one
> spinlock that's only taken from NMI context and thus hasn't got any
> deadlock potential.

Which one?

    J
