Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab1DHU7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:59:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56568 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab1DHU7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JsxgRFwrVnbh6dTbdGM0M6Gjm1b6Z35YOrTosQUtj4Bjrzx5E2pxjwhrEAVe5EP56W
         pEy5oXOMr38/hLDj29N6RfoMfXZqz09l5j2B+EAduvFQKUFjTRHe77peZrrO/jlGf84T
         iaWJvrgQ2pSLydZVdqfYJ5mUSMYnZMzZivgoE=
Message-ID: <4D9F7736.4070509@gmail.com>
Date: Fri, 08 Apr 2011 14:59:34 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        KVM mailing list <kvm@vger.kernel.org>
Subject: Re: trace-cmd errors on kvm events
References: <4D9F59AC.6080707@gmail.com> <BANLkTi=3FmfeATtdMV1J6ipexk49pvD_BQ@mail.gmail.com>
In-Reply-To: <BANLkTi=3FmfeATtdMV1J6ipexk49pvD_BQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/08/11 14:50, Stefan Hajnoczi wrote:
> On Fri, Apr 8, 2011 at 7:53 PM, David Ahern <dsahern@gmail.com> wrote:
>> 2.6.38.2 kernel with trace-cmd git pulled this morning:
>>
>> trace-cmd record -e kvm
>>
>> trace-cmd report 2>&1 | less
>>
>> trace-cmd: No such file or directory
>>  function ftrace_print_symbols_seq not defined
>>  failed to read event print fmt for kvm_nested_vmexit_inject
>>  function ftrace_print_symbols_seq not defined
>>  failed to read event print fmt for kvm_nested_vmexit
>>  function ftrace_print_symbols_seq not defined
>>  failed to read event print fmt for kvm_exit
>>  bad op token {
>>  failed to read event print fmt for kvm_emulate_insn
>>
>>        qemu-kvm-1864  [002]  2253.714134: kvm_entry:            vcpu 1
>>        qemu-kvm-1863  [008]  2253.714136: kvm_exit:             [FAILED
>> TO PARSE] exit_reason=44 guest_rip=0xc01185ed isa=1 info1=4272 info2=0
>>        qemu-kvm-1864  [002]  2253.714138: kvm_exit:             [FAILED
>> TO PARSE] exit_reason=44 guest_rip=0xc01185ed isa=1 info1=4272 info2=0
>>        qemu-kvm-1863  [008]  2253.714145: kvm_emulate_insn:     [FAILED
>> TO PARSE] rip=3222373869 csbase=0 len=2 insn=<89>^H]<C3><8B>^U<EC><95>K<C0>U
>> <89><E5>]<8D>^E flags=5 failed=0
>>
>> I have not used trace-cmd much, so I am not familiar with the code. Is
>> this a known issue? Suggestions on how to debug?
> 
> I think there have been issues for a long time.  I've never gotten
> perf or trace-cmd to be happy with kvm:* events.  Here is a related
> thread from a while back:
> 
> https://lkml.org/lkml/2010/5/26/194
> 
> When I looked a while back the problem was due to how there is some
> preprocessor magic in Linux that ends up exporting C expressions as
> strings to userspace and neither perf nor trace-cmd have the parsing
> smarts to evaluate the C expressions at runtime.

Hmm.. ok. I thought it had been added - to trace-cmd at least. And I
recall Avi recently sending a patch to trace-cmd folks - I took that to
mean it works. Evidently, not.

David


> 
> I ended up using ftrace instead which handles everything inside the
> kernel and compiles in those C expressions.
> 
> Stefan
