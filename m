Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab2EaXDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 19:03:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59077 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244Ab2EaXDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 19:03:09 -0400
References: <1338493218-25006-1-git-send-email-konrad.wilk@oracle.com> <4FC7D2AE.9080603@zytor.com> <20120531203544.GA19420@phenom.dumpdata.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120531203544.GA19420@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86/i386: Check PSE bit before using PAGE_KERNEL_LARGE.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 31 May 2012 16:02:11 -0700
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: konrad@darnok.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        mingo@redhat.com, tglx@linutronix.de, stable@kernel.org
Message-ID: <91130b9a-1324-4435-b642-427c2aa23121@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, PAE kernels cannot boot on non-PAE hardware.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

>On Thu, May 31, 2012 at 01:21:02PM -0700, H. Peter Anvin wrote:
>> On 05/31/2012 12:40 PM, Konrad Rzeszutek Wilk wrote:
>> > During bootup we would unconditionally do this on any
>> > machine that was built with CONFIG_NUMA=y on i386:
>> > 
>> > setup_arch
>> >   \-initmem_init
>> >       \-x86_numa_init (with dummy_init as callback)
>> >           \- init_alloc_remap
>> >                \- set_pmd_pfn (with PAGE_PSE)
>> > 
>> > without checking to see if the CPU supports PSE. This
>> > patch adds that and also allows the init_alloc_remap function
>> > to properly work by falling back on PTEs.
>> > 
>> 
>> Well, the code looks like it is PAE-specific, and PAE implies PSE.
>
>I have to double check - but I think a kernel built with
>CONFIG_HIGHMEM64=y
>and CONFIG_NUMA=y would boot on a Pentium II which can't do PAE.
>
>But perhaps there are some other checks that would halt the kernel
>before it even got there?
>
>> 
>> Xen breaks that, but that is a divergence of Xen from x86.
>
>It certainly does <sigh>. And that is how I spotted this - b/c the
>PMD would fail (with tons of mutlicalls warnings) - and the PTE's
>would still point to the old PFNs.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
