Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992566Ab2KOCXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 21:23:52 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:46341 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167Ab2KOCXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 21:23:50 -0500
Message-ID: <50A45228.3060404@linux.vnet.ibm.com>
Date: Thu, 15 Nov 2012 10:23:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Josh Boyer <jwboyer@gmail.com>, David Howells <dhowells@redhat.com>,
        mingo@kernel.org, haodong@linux.vnet.ibm.com,
        runzhen@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de,
        bp@alien8.de, namhyung@gmail.com, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [GIT PULL] UAPI: perf fixes
References: <1378.1352379110@warthog.procyon.org.uk> <CA+5PVA5vMyNmQYCLX315Jc+kN9zQuZo_h0Devpjfr43TezE-qA@mail.gmail.com> <18065.1352820271@warthog.procyon.org.uk> <CA+5PVA6qaxCzr8RBV616D3kEXyj9XjS3okeZXhJJL1R4+-Yv_A@mail.gmail.com> <20121113163458.GA1023@ghostprotocols.net>
In-Reply-To: <20121113163458.GA1023@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12111502-2000-0000-0000-000009DE8A8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 12:34 AM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 13, 2012 at 10:42:02AM -0500, Josh Boyer escreveu:
>> On Tue, Nov 13, 2012 at 10:24 AM, David Howells <dhowells@redhat.com> wrote:
>>> Josh Boyer <jwboyer@gmail.com> wrote:
>>> tools/perf/builtin-kvm.c became x86-only with the following commit:
>>>
>>>         commit bcf6edcd6fdb8965290f0b635a530fa3c6c212e1
>>>         Author: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>         Date:   Mon Sep 17 16:31:15 2012 +0800
>>>         Subject: perf kvm: Events analysis tool
>>>
>>> when it added:
>>>
>>>         +#include "../../arch/x86/include/asm/svm.h"
>>>         +#include "../../arch/x86/include/asm/vmx.h"
>>>         +#include "../../arch/x86/include/asm/kvm.h"
>>>
>>> and my changing these to <asm/foo.h> doesn't matter because of this in the
>>> same file:
>>>
>>>         +struct exit_reasons_table vmx_exit_reasons[] = {
>>>         +       VMX_EXIT_REASONS
>>>         +};
>>>         +
>>>         +struct exit_reasons_table svm_exit_reasons[] = {
>>>         +       SVM_EXIT_REASONS
>>>         +};
>>>
>>> which use macros only x86 defines.
>>
>> Ah.  You are quite right.  So your patches actually fix the unistd.h
>> error we were seeing early and just got us far enough to hit this other
>> unrelated problem.  My mistake.
>>
>>> Should the exported parts of these files be moved to asm-generic?
>>
>> Good question.
> 
> Probably we should do Makefile changes to build 'perf kvm' only on the
> platforms where it makes sense.

Only 'perf kvm stat' command is only supported on x86, how about add
"#ifdef ARCH_X86_64" around these code?


