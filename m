Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2DDUNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:13:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab2DDUNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120404123033.GD11918@redhat.com>
References: <1333414472.11455.7.camel@lappy> <20120403105226.GF14939@redhat.com>
 <20120404123033.GD11918@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 4 Apr 2012 22:13:13 +0200
Message-ID: <CA+1xoqfarN2+4p+dGmjSu+YUtLiCqNqATF5yVyAnE7YMDRn1sg@mail.gmail.com>
Subject: Re: kvm: RCU warning in async pf
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 2:30 PM, Gleb Natapov <gleb@redhat.com> wrote:
> On Tue, Apr 03, 2012 at 01:52:26PM +0300, Gleb Natapov wrote:
>> On Mon, Apr 02, 2012 at 08:54:32PM -0400, Sasha Levin wrote:
>> > Hi all,
>> >
>> > I got the spew at the bottom of the mail in a KVM guest using the KVM tools and running trinity.
>> >
>> > I'm not quite sure how default_idle managed to trigger a pagefault, so that part looks odd to me.
>> >
>> This is not regular page fault. This is async page fault that tells the
>> guest that a page, previously swapped out by hypervisor, is now swapped
>> back in and it can happen while vcpu is idle. The code does not leave
>> idle state properly though. We probably need to call rcu_irq_enter()
>> there. Will look into it.
>>
>
> The patch below solves it for me:
>
> "Page ready" async PF can kick vcpu out of idle state much like IRQ.
> We need to tell RCU about this.

Looks good here.
