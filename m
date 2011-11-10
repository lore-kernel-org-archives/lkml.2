Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab1KJJsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:48:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab1KJJss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:48:48 -0500
From: Markus Armbruster <armbru@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
	<4EBB4A21.20707@codemonkey.ws>
	<alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
	<m3pqh0tnoi.fsf@blackfin.pond.sub.org>
	<CA+1xoqe22z9F3ZyFG_XnV9Y17HtkeSxtf1gbW4+CW1cuNQ=N5g@mail.gmail.com>
	<m3fwhws6ci.fsf@blackfin.pond.sub.org>
	<CA+1xoqc7f-2azcjuLB_i_C_CCDt+gPqJe=SB5MmOiM0y6uY_cg@mail.gmail.com>
Date: Thu, 10 Nov 2011 10:48:07 +0100
In-Reply-To: <CA+1xoqc7f-2azcjuLB_i_C_CCDt+gPqJe=SB5MmOiM0y6uY_cg@mail.gmail.com>
	(Sasha Levin's message of "Thu, 10 Nov 2011 11:04:46 +0200")
Message-ID: <m3ipmspaug.fsf@blackfin.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On Thu, Nov 10, 2011 at 10:57 AM, Markus Armbruster <armbru@redhat.com> wrote:
>> Sasha Levin <levinsasha928@gmail.com> writes:
[...]
>>> I'm actually not sure why KVM tool got QCOW support in the first
>>> place. You can have anything QCOW provides if you use btrfs (among
>>> several other FSs).
>>
>> Maybe it's just me, but isn't it weird to have a filesystem (QCOW2)
>> sitting in the kernel sources that you can't mount(2)?
>>
>
> It's not really a filesystem, it's a disk image :)

Sloppy language on my part, sorry about that.

It's a transport for blocks.  We have a few of those in the kernel
already: block devices.  Including loop devices and DRBD.  You use a
filesystem to interpret their contents.  The resulting stack is what
gets mounted.  Adding another transport for blocks to the kernel that
cannot be used that way strikes me as weird.

[...]
