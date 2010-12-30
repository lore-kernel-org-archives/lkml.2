Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0L3VSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 16:18:41 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54067 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0L3VSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 16:18:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qnZ9TY27YRkyWWB2CL2W6DPCJKicCEiuuInwSF1qZjDgzPdHbF2D/gclzkHsG9qxbi
         Dax1Gd0XXX4oKXqlWTVCUGzM7iabI4JRhUVfaNFRceG+k9w+3CjxmazDPUWA2Q1B1d4S
         6hPIrXooMP5E5vxyPw767SpWopFNHo+HMd3VI=
MIME-Version: 1.0
In-Reply-To: <20101230103002.GA30020@elte.hu>
References: <4D1933D1.9020609@kernel.org>
	<4D1BC856.4010202@kernel.org>
	<4D1BC94C.5040100@zytor.com>
	<AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com>
	<alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com>
	<4D1BD928.50701@zytor.com>
	<alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>
	<4D1BE615.4000700@zytor.com>
	<20101230090648.GB7306@elte.hu>
	<20101230102815.GA29822@elte.hu>
	<20101230103002.GA30020@elte.hu>
Date: Thu, 30 Dec 2010 13:18:39 -0800
X-Google-Sender-Auth: y1QjjXgtfk_4zHaaP6c3pCt4ZTo
Message-ID: <AANLkTimeqrLzDuqBoSvmkSJWMc7u3PeRf37vjzBca2Lh@mail.gmail.com>
Subject: Re: [boot crash] Re: [PATCH -v2 3/6] x86, 64bit, numa: Put pgtable to
 local node memory
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 2:30 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> FYI, either the x86/numa or the x86/bootmem changes cause the early boot crash
>> below. Config attached.
>
> It's x86/bootmem, one of these commits:
>
> 3c417751e4f0: x86: Rename e820_table_* to pgt_buf_*
> d7992231c148: x86-64: Move out cleanup higmap [_brk_end, _end) out of init_memory_mapping()
> 4645b6af9427: x86: Use early pre-allocated page table buffer top-down
> 1411e0ec3123: x86-64, numa: Put pgtable to local node memory
> dbef7b56d2fc: x86-64, numa: Allocate memnodemap under max_pfn_mapped
> 45635ab5e41b: x86: Change get_max_mapped() to inline
> 1a4a678b12c8: memblock: Make find_memory_core_early() find from top-down
> 32e3f2b00c52: x86-64, gart: Fix allocation with memblock
> 4b239f458c22: x86-64, mm: Put early page table high
>
> i'm excluding them from tip:master for now.

caused by
4645b6af9427: x86: Use early pre-allocated page table buffer top-down

32 bit fixmap will use the pre-allocated range too. it needs range to
be continuous...

please drop
4645b6af9427: x86: Use early pre-allocated page table buffer top-down
3c417751e4f0: x86: Rename e820_table_* to pgt_buf_*

and will send out new version of

 x86: Rename e820_table_* to pgt_buf_*

Thanks

Yinghai
