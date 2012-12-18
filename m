Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab2LRWYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:24:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34419 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab2LRWYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:24:38 -0500
Message-ID: <50D0ED00.60804@zytor.com>
Date: Tue, 18 Dec 2012 14:24:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH 6/6] Add 32 bit VDSO support for 32 and 64 bit kernels
References: <1355823656-13902-1-git-send-email-stefani@seibold.net> <1355823656-13902-7-git-send-email-stefani@seibold.net> <50D09733.3080502@zytor.com> <1355849558.26967.24.camel@wall-e> <50D0B986.7020009@zytor.com> <1355862759.28056.14.camel@wall-e> <CALCETrX2zAA-X7fjoPNSERq0kVDDY43O_u=Oqjq77_ggf64j9A@mail.gmail.com>
In-Reply-To: <CALCETrX2zAA-X7fjoPNSERq0kVDDY43O_u=Oqjq77_ggf64j9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 12:37 PM, Andy Lutomirski wrote:
>>
>> There is no introduce of new fix address. There are still there for
>> x86_64. If this will currently not a major problem on this architecture
>> than it will not for x86_32 too.
>
> Not necessarily true.  On x86-64 (non-compat) the fixmap address is in
> kernel space (high bit set), so it can't conflict with anything in
> user space.  On true 32-bit mode, the same applies.  In compat mode,
> the fixed address is in *user* space and might conflict with existing
> uses.
>

The other bit is that the fixmap isn't actually fixed on 32 bits, which 
creates its own set of problems.  As such, I really would prefer a 
properly PIC solution.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

