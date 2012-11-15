Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2KOGQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:16:37 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:61632 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2KOGQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:16:34 -0500
Message-ID: <50A48882.3030204@synopsys.com>
Date: Thu, 15 Nov 2012 11:45:30 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Gilad Ben-Yossef <gilad@benyossef.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>
Subject: Re: [RFC PATCH v1 14/31] ARC: syscall support
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211071421.39523.arnd@arndb.de> <CAOtvUMcc-7mBxYWEe7oypri7wxf58R8cph7EpdLYR_fLHO6eTg@mail.gmail.com> <201211131037.43526.arnd@arndb.de>
In-Reply-To: <201211131037.43526.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012 04:07 PM, Arnd Bergmann wrote:
> On Tuesday 13 November 2012, Gilad Ben-Yossef wrote:
>> So, I completely agree about not adding more deprecated system call or
>> ABIs (thinking about the ptrace regset issues in another patch in the
>> same patchset), but on the other hand I have to wonder if having a
>> port in the tree that doesn't have a working C library or a debugger
>> makes sense.
>>
>> I mean, it is not quite the same thing as saying: "well, users of the
>> old versions of the user tools will need to maintain out of tree
>> patches". That makes sense - it puts the burden of maintenance on
>> people clinging to new versions when newer one exists, but this is not
>> what is happening with Arc. Right now, there are no working version of
>> the tools for Arc, so everyone will need to use the out of tree
>> patches.
>>
>> I wonder what is worse - having an in tree port that no one (can) use
>> or adding some deprecated crap (sorry...), clearly marked for deletion
>> the minute a version of the relevant user tools exists that can be
>> used with the new mechanisms?
> The point is that all existing users already need to rebuild all their
> user space since the upstream version is using the generic system call
> numbers. What I want to avoid is breaking everything twice, and the most
> logical point to do that is when moving from an out-of-tree kernel fork
> to the mainline version.

I completely agree.

> If mainline doesn't work for you yet, the most logical choice is to
> stay on whatever kernel you have working right now, and only change
> over to the upstream version once it works with an ABI that we want
> to maintain in the long term. Obviously I can't stop from using a
> mix of the two while you are waiting for (or working on) getting
> gdb and uclibc supported with the new interface, but my recommendation
> is not to ship that in products to end-users that would suffer
> from another ABI change later on. 
>
> What I'm trying to enforce here is that the upstream version follows
> the exact same rules that we apply to all other ports, which is
> that we don't break existing user space that was running with an
> older upstream kernel.

So the primary concern here is not breaking the userspace ABI - right ?

For syscalls I agree that we will indeed need to fix the ABI - by fixing
uClibc. And if uClibc doesn't merge the fixes we can stay out of tree
for uClibc - as we currently already are.

For gdbserver, the kernel provides the complete regset ABI. However it
also provides a very limited version of old ABI - i.e. ptrace with
PEEKUSR/POKEUSR. Note that latter is just a shim layer and it reuses the
regset callbacks. This allows us to support the legacy gdbserver. If and
when gdbserver upgrades it can switch over to new interface. So all
along there will be NO ABI breakage at all. The cost is couple extra
functions in kernel which we might have to maintain for some foreseeable
future. Agree ?

-Vineet
