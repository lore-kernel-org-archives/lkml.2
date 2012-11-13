Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2KMPmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:42:07 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54245 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2KMPmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:42:03 -0500
MIME-Version: 1.0
In-Reply-To: <18065.1352820271@warthog.procyon.org.uk>
References: <1378.1352379110@warthog.procyon.org.uk>
	<CA+5PVA5vMyNmQYCLX315Jc+kN9zQuZo_h0Devpjfr43TezE-qA@mail.gmail.com>
	<18065.1352820271@warthog.procyon.org.uk>
Date: Tue, 13 Nov 2012 10:42:02 -0500
Message-ID: <CA+5PVA6qaxCzr8RBV616D3kEXyj9XjS3okeZXhJJL1R4+-Yv_A@mail.gmail.com>
Subject: Re: [GIT PULL] UAPI: perf fixes
From: Josh Boyer <jwboyer@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: acme@ghostprotocols.net, xiaoguangrong@linux.vnet.ibm.com,
        mingo@kernel.org, haodong@linux.vnet.ibm.com,
        runzhen@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de,
        bp@alien8.de, namhyung@gmail.com, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 10:24 AM, David Howells <dhowells@redhat.com> wrote:
> Josh Boyer <jwboyer@gmail.com> wrote:
>
>> This patch seems to break building perf on ppc64.  It fails with:
>>
>> + make -j16 -C tools/perf -s V=1 WERROR=0 HAVE_CPLUS_DEMANGLE=1 prefix=/usr all
>>
>> <snip>
>>
>> builtin-kvm.c:25:21: fatal error: asm/svm.h: No such file or directory
>
> tools/perf/builtin-kvm.c became x86-only with the following commit:
>
>         commit bcf6edcd6fdb8965290f0b635a530fa3c6c212e1
>         Author: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>         Date:   Mon Sep 17 16:31:15 2012 +0800
>         Subject: perf kvm: Events analysis tool
>
> when it added:
>
>         +#include "../../arch/x86/include/asm/svm.h"
>         +#include "../../arch/x86/include/asm/vmx.h"
>         +#include "../../arch/x86/include/asm/kvm.h"
>
> and my changing these to <asm/foo.h> doesn't matter because of this in the
> same file:
>
>         +struct exit_reasons_table vmx_exit_reasons[] = {
>         +       VMX_EXIT_REASONS
>         +};
>         +
>         +struct exit_reasons_table svm_exit_reasons[] = {
>         +       SVM_EXIT_REASONS
>         +};
>
> which use macros only x86 defines.

Ah.  You are quite right.  So your patches actually fix the unistd.h
error we were seeing early and just got us far enough to hit this other
unrelated problem.  My mistake.

> Should the exported parts of these files be moved to asm-generic?

Good question.

josh
