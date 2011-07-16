Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab1GPAOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 20:14:52 -0400
Received: from claw.goop.org ([74.207.240.146]:45379 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab1GPAOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 20:14:51 -0400
Message-ID: <4E20D7E9.6070802@goop.org>
Date: Fri, 15 Jul 2011 17:14:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove duplicate
 code
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <4E0506A8.3010102@zytor.com> <4E0512BC.5010900@goop.org> <1ade2577-044b-4391-a607-91a4a989c3ff@email.android.com> <4E2077E1.4060606@goop.org> <4E20C80A.4050307@zytor.com>
In-Reply-To: <4E20C80A.4050307@zytor.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 04:06 PM, H. Peter Anvin wrote:
> On 07/15/2011 10:24 AM, Jeremy Fitzhardinge wrote:
>> I posted a bug about gcc not generating cmp %ah, %al in this case, but the general consensus was that
>> it's not a good choice on current Intel chips, because it causes a partial word stall, and that the
>> current generated code is better.  (And gcc can generate "cmp %Xh, %Xl" if it wants to - see below.)
>>
> Which version of gcc is this, and also, do you have the gcc bug report
> number?  I was talking to H.J. and he said he thought it sounded strange.

gcc version 4.6.0 20110530 (Red Hat 4.6.0-9) (GCC)

It's bug 47556.

    J
