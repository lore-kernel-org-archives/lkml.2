Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2BMQvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:51:03 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49103 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab2BMQvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:51:00 -0500
MIME-Version: 1.0
In-Reply-To: <m1zkcmyjyd.fsf@fess.ebiederm.org>
References: <tip-d9bc9be89629445758670220787683e37c93f6c1@git.kernel.org>
	<CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
	<m1ipjc3fsk.fsf@fess.ebiederm.org>
	<CAE9FiQVLnyRB+pAqi22C5mCbHOOVKxsBhQKaB6P0p9f2LBL8bA@mail.gmail.com>
	<m1zkcmyjyd.fsf@fess.ebiederm.org>
Date: Mon, 13 Feb 2012 08:51:00 -0800
X-Google-Sender-Auth: cGL--GRlsz1hXu4L_Bo_SlS7ZZ0
Message-ID: <CAE9FiQVj12UCGbOe4wZfx-L8tdab-1si-RA=vBnNeZ7cUNqyyg@mail.gmail.com>
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 4:52 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>
>> On Sat, Feb 11, 2012 at 7:13 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Yinghai Lu <yinghai@kernel.org> writes:
>>>> After reverting this commit, kdump is working again.
>>>>
>>>> So assume you need to drop this patch.
>>>
>>> It sounds like there is a bug in ioapic initialization in the context of
>>> VT-d.  Where do you fail?
>>>
>> before get debug print out from second kernel, the system get reset.
>
> Ouch.
>
> Don can you work with with Yinghai to figure out what is different
> between your test configuration and his?
>
> YH did you have early printk enabled?

yes.

I always have "console=uart8250,io,0x3f8,115200n8" appended.

also i have local patches that print info from
arch/x86/boot/compressed/misc.c::decompress_kernel()
and
arch/x86/kernel/head64.c::x86_64_start_kernel()

>
> YH Did I understand you properly that things work if you don't enable
> VT-d?

that is default setting for BIOS and OS.

will check if disable that will help.

> By VT-d are you referring to interrupt remapping?

yes, include interrupt rempapping and dma remapping.

>
> For anyone watching.  The premise of this patch was that we can boot
> the kernel without resorting to legacy tricks that require us to
> put the interrupt controllers in PIT mode.
>
> Apparently there is some weird corner case that YH can reproduce that
> Don did not have in his test set that YH does that causes things to
> fail.
>
> I really don't see any likely candidates when looking at the code.  The
> most I can see is some code that we don't run when interrupt remapping
> is enabled in disable_IO_APIC.
>
> So I suspect we have a bug in our apic initialization somewhere, but
> apic initialization should happen after printk are enabled.  Or at least
> after early printks so the reset YH is reporting doesn't make much sense.

will try Don's first version patch that only removing disable_IO_APIC.

Yinghai
