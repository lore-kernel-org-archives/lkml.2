Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031469Ab2K3Sk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:40:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35466 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031444Ab2K3Skw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:40:52 -0500
Message-ID: <50B8FD9A.3040703@zytor.com>
Date: Fri, 30 Nov 2012 10:40:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com> <1354132230-21854-9-git-send-email-hpa@linux.intel.com> <20121128204158.GC14635@liondog.tnic> <50B7D28A.4000401@linux.intel.com> <CA+55aFziiaWt1nU-EPKc=tFd0EvSm2iSBJ2MAqxNiWP5O0mv+w@mail.gmail.com> <50B8F4D7.2010204@zytor.com> <20121130181037.GE23034@liondog.tnic>
In-Reply-To: <20121130181037.GE23034@liondog.tnic>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 10:10 AM, Borislav Petkov wrote:
> On Fri, Nov 30, 2012 at 10:03:03AM -0800, H. Peter Anvin wrote:
>> Well, the grand total of serializing instructions are:
>>
>> INVD, INVEPT, INVLPG, INVVPID, LGDT, LIDT, LLDT, LTR, MOV to CR, MOV
>> to DR, WBINVD, WRMSR, CPUID, IRET, RSM.
> 
> What about MFENCE with JMP 1f to kill prefetches? Probably too
> expensive. Oh and MFENCE is an SSE2 insn so maybe not supported by 486
> or something later ...

It's not serializing in the strict sense.

	-hpa

