Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927Ab1KJJFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:05:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47287 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933598Ab1KJJFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:05:08 -0500
MIME-Version: 1.0
In-Reply-To: <m3fwhws6ci.fsf@blackfin.pond.sub.org>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
 <4EBB4A21.20707@codemonkey.ws> <alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
 <m3pqh0tnoi.fsf@blackfin.pond.sub.org> <CA+1xoqe22z9F3ZyFG_XnV9Y17HtkeSxtf1gbW4+CW1cuNQ=N5g@mail.gmail.com>
 <m3fwhws6ci.fsf@blackfin.pond.sub.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 10 Nov 2011 11:04:46 +0200
Message-ID: <CA+1xoqc7f-2azcjuLB_i_C_CCDt+gPqJe=SB5MmOiM0y6uY_cg@mail.gmail.com>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
To: Markus Armbruster <armbru@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:57 AM, Markus Armbruster <armbru@redhat.com> wrote:
> Sasha Levin <levinsasha928@gmail.com> writes:
>
>> On Thu, Nov 10, 2011 at 9:57 AM, Markus Armbruster <armbru@redhat.com> wrote:
> [...]
>>> Start with a clean read/write raw image.  Probing declares it raw.
>>> Guest writes QCOW signature to it, with a backing file of its choice.
>>>
>>> Restart with the same image.  Probing declares it QCOW2.  Guest can read
>>> the backing file.  Oops.
>>
>> Thats an excellent scenario why you'd want to have 'Secure KVM' with
>> seccomp filters :)
>
> Yup.
>
> For what it's worth, sVirt (use SELinux to secure virtualization)
> mitigates the problem.  Doesn't mean we couldn't use "Secure KVM".

How does it do it do that? You have a hypervisor trying to read
arbitrary files on the host FS, no?

>> I'm actually not sure why KVM tool got QCOW support in the first
>> place. You can have anything QCOW provides if you use btrfs (among
>> several other FSs).
>
> Maybe it's just me, but isn't it weird to have a filesystem (QCOW2)
> sitting in the kernel sources that you can't mount(2)?
>

It's not really a filesystem, it's a disk image :)

When we did the initial QCOW patches this issue (in some form) came
up. The main concern there was that we shouldn't be duplicating QCOW
code and instead be using a 'libdiskimage' or something like that.

Since nothing like that existed at that time, and splitting it out of
QEMU wasn't trivial, we ended up agreeing on doing a rewrite of the
code.

The point you raised could be solved if we do end up having a usermode
lib which can handle disk images.
