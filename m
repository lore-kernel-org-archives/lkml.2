Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab2CGS1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:27:12 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53737 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2CGS1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:27:09 -0500
MIME-Version: 1.0
In-Reply-To: <20120307155018.GA13430@redhat.com>
References: <20120216215603.GH9751@redhat.com>
	<m1y5s2ku36.fsf@fess.ebiederm.org>
	<m1fwe9bpk2.fsf@fess.ebiederm.org>
	<20120217195430.GO9751@redhat.com>
	<m1y5s07rn3.fsf@fess.ebiederm.org>
	<20120220151419.GU9751@redhat.com>
	<m1obss39a4.fsf@fess.ebiederm.org>
	<20120221135934.GF26998@redhat.com>
	<m1ipip6xe8.fsf@fess.ebiederm.org>
	<4F573E1C.2060909@oss.ntt.co.jp>
	<20120307155018.GA13430@redhat.com>
Date: Wed, 7 Mar 2012 10:27:07 -0800
X-Google-Sender-Auth: qkxEeS_iz8Vg8oi9qI4zaukNHP4
Message-ID: <CAE9FiQXLMzVLH7MW2OXFCpBU+5RRN-EnshGYhkj_3sO36c1Mkg@mail.gmail.com>
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        mingo@elte.hu, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/7 Vivek Goyal <vgoyal@redhat.com>:
> On Wed, Mar 07, 2012 at 07:53:16PM +0900, Fernando Luis Vázquez Cao wrote:
>> On 03/01/2012 08:19 AM, Eric W. Biederman wrote:
>>
>> >Don Zickus<dzickus@redhat.com>  writes:
>> >>It probably is, except I never hacked on idt code before and my assembly
>> >>isn't that good.  I have been trying to find examples to copy from to give
>> >>it a try.  So far I was using early_idt_handlers with early_printk to see
>> >>if I could capture some printk messages while jumping from the first
>> >>kernel to the second kernel (when the other early_idt_handlers would kick
>> >>in for the second kernel).
>> >>
>> >>Tips?  Better examples?
>> >That is a particularly good example.  When I took a quick look earlier
>> >that is the first place we reload the idt in the kernel boot so that is
>> >one of two places that needs to be modified.
>>
>> Hi Eric, Don
>>
>> Sorry for chiming in so late.
>>
>> We run into the same NMI problems and wrote some patches that tackle
>> the kernel boot side of things. They have been extensively tested using
>> qemu-kvm and things seem to be working as expected (after receiving an
>> early NMI the kernel continues without problem; after the iret there is no
>> stack corruption or register corruption).
>
> What happens if NMI happens while we are still in purgatory code?
>
yes, you are right. that is too late to set that in arch/x86/kernel/head64.c

i even not get print out "early console in decompress_kernel"
from arch/x86/boot/compressed/misc.c::decompress_kernel()

Yinghai
