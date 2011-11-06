Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab1KFLus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 06:50:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab1KFLur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 06:50:47 -0500
Message-ID: <4EB67486.1070105@redhat.com>
Date: Sun, 06 Nov 2011 13:50:30 +0200
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
References: <1320543320-32728-1-git-send-email-agraf@suse.de>  <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>  <4EB65C5B.8070709@redhat.com>  <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>  <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar>
In-Reply-To: <1320577728.1428.73.camel@jaguar>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 01:08 PM, Pekka Enberg wrote:
> On Sun, 2011-11-06 at 12:23 +0200, Avi Kivity wrote:
> > In most installations, qemu is driven by other programs, so any changes
> > to the command line would be invisible, except insofar as they break things.
> > 
> > For the occasional direct user of qemu, something like 'qemu-kvm -m 1G
> > /images/blah.img' is enough to boot an image.  This script doesn't help
> > in any way.
> > 
> > This script is for kernel developers who don't want to bother with
> > setting up a disk image (which, btw, many are still required to do - I'm
> > guessing most kernel developers who use qemu are cross-arch).  It has
> > limited scope and works mostly by hiding qemu features.  As such it
> > doesn't belong in qemu.
>
> I'm certainly not against merging the script if people are actually
> using it and it solves their problem.
>
> I personally find the whole exercise pointless because it's not
> attempting to solve any of the fundamental issues QEMU command line
> interface

There are no "fundamental qemu command line issues".  It's hairy, yes,
and verbose, but using "fundamental" to describe a choice between one
arcane set command line options and another is a bit of overstatement. 
Most users will use a GUI anyway.

>  has nor does it try to make Linux on Linux virtualization
> simpler and more integrated.

So far, kvm-tool capabilities are a subset of qemu's.  Does it add
anything beyond a different command-line?

> People seem to think the KVM tool is only about solving a specific
> problem to kernel developers. That's certainly never been my goal as I
> do lots of userspace programming as well. The end game for me is to
> replace QEMU/VirtualBox for Linux on Linux virtualization for my day to
> day purposes.

Maybe it should be in tools/pekka then.  Usually subsystems that want to
be merged into Linux have broaded audiences though.

-- 
error compiling committee.c: too many arguments to function

