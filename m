Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab1KHO5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:57:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730Ab1KHO53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:57:29 -0500
Message-ID: <4EB94340.5040205@redhat.com>
Date: Tue, 08 Nov 2011 16:57:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Pekka Enberg <penberg@kernel.org>,
        Am?rico Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <4EB93FA4.8020800@redhat.com> <20111108145257.GA10846@infradead.org>
In-Reply-To: <20111108145257.GA10846@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 04:52 PM, Christoph Hellwig wrote:
> On Tue, Nov 08, 2011 at 04:41:40PM +0200, Avi Kivity wrote:
> > On 11/06/2011 03:35 AM, Alexander Graf wrote:
> > > To quickly get going, just execute the following as user:
> > >
> > >     $ ./Documentation/run-qemu.sh -r / -a init=/bin/bash
> > >
> > > This will drop you into a shell on your rootfs.
> > >
> > 
> > Doesn't work on Fedora 15.  F15's qemu-kvm doesn't have -machine or
> > -virtfs.  Even qemu.git on F15 won't build virtfs since xattr.h
> > detection is broken (patch posted).
>
> Nevermind that running virtfs as a rootfs is a really dumb idea.  You
> do now want to run a VM that has a rootfs that gets changed all the
> time behind your back.

True.

> Running qemu -snapshot on the actual root block device is the only
> safe way to reuse the host installation, although it gets a bit
> complicated if people have multiple devices mounted into the namespace.

How is -snapshot any different?  If the host writes a block after the
guest has been launched, but before that block was cowed, then the guest
will see the new block.

It could work with a btrfs snapshot, but not everyone uses that.

-- 
error compiling committee.c: too many arguments to function

