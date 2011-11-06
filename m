Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab1KFKYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 05:24:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1KFKYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 05:24:37 -0500
Message-ID: <4EB66036.4080102@redhat.com>
Date: Sun, 06 Nov 2011 12:23:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
In-Reply-To: <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 12:12 PM, Pekka Enberg wrote:
> On Sun, Nov 6, 2011 at 12:07 PM, Avi Kivity <avi@redhat.com> wrote:
> >> I'm happy to see some real competition for the KVM tool in usability. ;-)
> >>
> >> That said, while the script looks really useful for developers,
> >> wouldn't it make more sense to put it in QEMU to make sure it's kept
> >> up-to-date and distributions can pick it up too? (And yes, I realize
> >> the irony here.)
> >
> > Why would distributions want it?  It's only useful for kernel developers.
>
> It's useful for kernel testers too.

Well, they usually have a kernel with them.

> If this is a serious attempt in making QEMU command line suck less on
> Linux, I think it makes sense to do this properly instead of adding a
> niche script to the kernel tree that's simply going to bit rot over
> time.

You misunderstand.  This is an attempt to address the requirements of a
niche population, kernel developers and testers, not to improve the qemu
command line.  For the majority of qemu installations, this script is
useless.

In most installations, qemu is driven by other programs, so any changes
to the command line would be invisible, except insofar as they break things.

For the occasional direct user of qemu, something like 'qemu-kvm -m 1G
/images/blah.img' is enough to boot an image.  This script doesn't help
in any way.

This script is for kernel developers who don't want to bother with
setting up a disk image (which, btw, many are still required to do - I'm
guessing most kernel developers who use qemu are cross-arch).  It has
limited scope and works mostly by hiding qemu features.  As such it
doesn't belong in qemu.

-- 
error compiling committee.c: too many arguments to function

