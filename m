Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1HVR0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 13:26:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53401 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1HVRZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 13:25:58 -0400
Message-ID: <4E5290D6.5050406@zytor.com>
Date: Mon, 22 Aug 2011 10:24:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        kernel-hardening@lists.openwall.com,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] x86, mm: start mmap allocation for libs from low addresses
References: <20110812102954.GA3496@albatros> <ccea406f-62be-4344-8036-a1b092937fe9@email.android.com> <20110816090540.GA7857@albatros> <20110822101730.GA3346@albatros>
In-Reply-To: <20110822101730.GA3346@albatros>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 03:17 AM, Vasiliy Kulikov wrote:
> Hi Ingo, Peter, Thomas,
> 
> On Tue, Aug 16, 2011 at 13:05 +0400, Vasiliy Kulikov wrote:
>> As the changes are not intrusive, we'd want to see this feature in the
>> upstream kernel.  If you know why the patch cannot be a part of the
>> upstream kernel - please tell me, I'll try to address the issues.
> 
> Any comments on the RFC?  Otherwise, may I resend it as a PATCH for
> inclusion?
> 
> Thanks!

Conceptually:

I also have to admit to being somewhat skeptical to the concept on a
littleendian architecture like x86.

Code-wise:

The code is horrific; it is full of open-coded magic numbers; it also
puts a function called arch_get_unmapped_exec_area() in a generic file,
which could best be described as "WTF" -- the arch_ prefix we use
specifically to denote a per-architecture hook function.

As such, your claim that the changes are not intrusive is plain false.

	-hpa
