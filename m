Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1KHO4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:56:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60831 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab1KHO4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:56:19 -0500
MIME-Version: 1.0
In-Reply-To: <20111108145257.GA10846@infradead.org>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
 <4EB93FA4.8020800@redhat.com> <20111108145257.GA10846@infradead.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 8 Nov 2011 16:55:57 +0200
Message-ID: <CA+1xoqe-T-GYHq8nm1vVTs5Tb3mcmxThywbLmTT+1TTXtZbVzw@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
To: Christoph Hellwig <hch@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Pekka Enberg <penberg@kernel.org>,
        "Am?rico Wang" <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 4:52 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Nov 08, 2011 at 04:41:40PM +0200, Avi Kivity wrote:
>> On 11/06/2011 03:35 AM, Alexander Graf wrote:
>> > To quickly get going, just execute the following as user:
>> >
>> >     $ ./Documentation/run-qemu.sh -r / -a init=/bin/bash
>> >
>> > This will drop you into a shell on your rootfs.
>> >
>>
>> Doesn't work on Fedora 15.  F15's qemu-kvm doesn't have -machine or
>> -virtfs.  Even qemu.git on F15 won't build virtfs since xattr.h
>> detection is broken (patch posted).
>
> Nevermind that running virtfs as a rootfs is a really dumb idea.  You
> do now want to run a VM that has a rootfs that gets changed all the
> time behind your back.
>
> Running qemu -snapshot on the actual root block device is the only
> safe way to reuse the host installation, although it gets a bit
> complicated if people have multiple devices mounted into the namespace.

Using block devices also requires root.
