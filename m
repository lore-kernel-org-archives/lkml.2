Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab2DPGZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:25:24 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38812 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2DPGZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:25:23 -0400
X-AuditID: b753bd60-9d3adba000002f45-43-4f8bbb4f0fb5
X-AuditID: b753bd60-9d3adba000002f45-43-4f8bbb4f0fb5
Message-ID: <4F8BBB4D.5090409@hitachi.com>
Date: Mon, 16 Apr 2012 15:25:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org> <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com> <CA+55aFwcf2uPCccCVrNdCENZVKyev=ARprNj=5zwp5vxD942pw@mail.gmail.com> <20120414010410.GB22114@infradead.org> <20120414085519.GB28505@gmail.com> <20120414162851.GD22114@infradead.org>
In-Reply-To: <20120414162851.GD22114@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/15 1:28), Arnaldo Carvalho de Melo wrote:
> Em Sat, Apr 14, 2012 at 10:55:19AM +0200, Ingo Molnar escreveu:
>>
>> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
>>
>>> Em Fri, Apr 13, 2012 at 11:30:52AM -0700, Linus Torvalds escreveu:
>>>> On Fri, Apr 13, 2012 at 11:25 AM, Linus Torvalds
>>>> <torvalds@linux-foundation.org> wrote:
>>>>>
>>>>> <kmem_cache_free>:
>>>>>    1.91 :          push   %rbp
>>>>
>>>> Oh, btw, talking about kmem_cache_free: that one uses altinstructions,
>>>> and so perf report shows the hottest instruction wrong (and I'm not
>>>> talking about "ugly"):
>>>
>>> Well, if we use Masami's disassembler we would use the actual 
>>> code as it is being used and not the original DSO that was 
>>> later patched by altinstructions.
>>
>> Key would be to use the kernel's live RAM image of instructions. 
> 
> Yeah, that is what I meant by "if we use Masami's disassembler" :-)
>  
>> I.e. we should provide a live /proc/vmlinux image in essence: a 
>> 'virtual' ELF binary image constructed out of the live kernel 
>> RAM image - with no extra RAM overhead. (Maybe with modules 
>> included in an intelligent way - although personally I don't use 
>> modules when I instrument the kernel)
>>
>> That plus the always-available /proc/kallsyms would offer rather 
>> powerful annotation already: without *any* debug info - out of 
>> box, on any Linux installation. (This was always the main 
>> advantage of /proc/profile and readprofile btw: it worked 
>> everywhere while most other profiling solutions needed a 
>> debuginfo, etc.)
>>
>> Doing /proc/vmlinux would be different from /dev/mem as it only 
>> shows the kernel RAM image, and only in a read-only fashion.

If we can ignore permissions, we can check whether the instruction
at the event address is modified or not in /dev/mem.
And that is also useful for modules. That can be done in userspace
with using setuid'd tool.

>> Default permissions of /proc/vmlinux should probably track 
>> console permissions: it should be possible to allow people 
>> sitting in front of the computer to read /proc/vmlinux, while 
>> people logged in over the network wouldn't.
>>
>> Doing such a live kernel vmlinux would have other debugging and 
>> instrumentation advantages as well: various code patching 
>> effects could be checked and observed directly.
> 
> I would say that even for userspace we would love to have such virtual
> ELF files, as code patching is become more common...

Right, if we hope to handle it correctly, we'll need to handle
all self-modifying code in kernel/user space.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
