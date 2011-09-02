Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab1IBTeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:34:19 -0400
Received: from claw.goop.org ([74.207.240.146]:45129 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab1IBTeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:34:17 -0400
Message-ID: <4E612FB6.9030904@goop.org>
Date: Fri, 02 Sep 2011 12:34:14 -0700
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
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 11/13] x86/ticketlock: only do kick after doing unlock
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>  <8cd2c77886e2d3fcad8258aa62509b3b2fae5545.1314922370.git.jeremy.fitzhardinge@citrix.com> <1314974968.1861.3.camel@twins>
In-Reply-To: <1314974968.1861.3.camel@twins>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 07:49 AM, Peter Zijlstra wrote:
> On Thu, 2011-09-01 at 17:55 -0700, Jeremy Fitzhardinge wrote:
>> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>>
>> We must release the lock before checking to see if the lock is in
>> slowpath or else there's a potential race where the lock enters the
>> slow path after the unlocker has checked the slowpath flag, but before
>> it has actually unlocked.
>>
>> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> 
> Wouldn't it be much better to fold it back so that this bug never
> happens when you bisect?

Yes indeed.

    J

