Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab1IBTc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:32:29 -0400
Received: from claw.goop.org ([74.207.240.146]:45109 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab1IBTc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:32:28 -0400
Message-ID: <4E612F49.9080100@goop.org>
Date: Fri, 02 Sep 2011 12:32:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Eric Northup <digitaleric@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/13] x86/ticketlock: add slowpath logic
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com> <8a788f3fbf2ad1316e462bf5aae623bab9d38319.1314922370.git.jeremy.fitzhardinge@citrix.com> <CAG7+5M0s76O_TWBaoY2KU+WeEoJYEhkLLDXfg81WHYNvavH3yw@mail.gmail.com>
In-Reply-To: <CAG7+5M0s76O_TWBaoY2KU+WeEoJYEhkLLDXfg81WHYNvavH3yw@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 11:46 AM, Eric Northup wrote:
> On Thu, Sep 1, 2011 at 5:54 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Maintain a flag in both LSBs of the ticket lock which indicates whether
>> anyone is in the lock slowpath and may need kicking when the current
>> holder unlocks.  The flags are set when the first locker enters
>> the slowpath, and cleared when unlocking to an empty queue.
> Are there actually two flags maintained?  I only see the one in the
> ticket tail getting set/cleared/tested.

Yeah, there's only one flag, so there's a spare bit in the other half.

    j

