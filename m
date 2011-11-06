Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1KFRQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 12:16:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab1KFRQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 12:16:05 -0500
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
Date: Sun, 6 Nov 2011 09:15:58 -0800
Cc: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
To: Pekka Enberg <penberg@kernel.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06.11.2011, at 05:06, Pekka Enberg wrote:

> On Sun, Nov 6, 2011 at 2:43 PM, Avi Kivity <avi@redhat.com> wrote:
>> You say that kvm-tool's scope is broader than Alex's script, therefore
>> the latter is pointless.
> 
> I'm saying that Alex's script is pointless because it's not attempting
> to fix the real issues. For example, we're trying to make make it as
> easy as possible to setup a guest and to be able to access guest data
> from the host. Alex's script is essentially just a simplified QEMU
> "front end" for kernel developers.
> 
> That's why I feel it's a pointless thing to do.

It's a script tailored to what Linus told me he wanted to see. I merely wanted to prove the point that what he wanted can be achieved without thousands and thousands of lines of code by reusing what is already there. IMHO less code is usually a good thing.

In fact, why don't you just provide a script in tools/testing/ that fetches KVM Tool from a git tree somewhere else and compiles it? It could easily live outside the kernel tree - you can even grab our awesome "fetch all Linux headers" script from QEMU so you can keep in sync with KVM header files.

At that point, both front ends would live in separate trees, could evolve however they like and everyone's happy, because KVM Tools would still be easy to use for people who want it by executing said shell script.

> 
> On Sun, Nov 6, 2011 at 2:43 PM, Avi Kivity <avi@redhat.com> wrote:
>> You accept that qemu's scope is broader than kvm-tool (and is a
>> superset).  That is why many people think kvm-tool is pointless.
> 
> Sure. I think it's mostly people that are interested in non-Linux
> virtualization that think the KVM tool is a pointless project.
> However, some people (including myself) think the KVM tool is a more
> usable and hackable tool than QEMU for Linux virtualization.

Sure. That's taste. If I think that tcsh is a better shell than bash do I pull it into the kernel tree just so "it lies there"? It definitely does use kernel interfaces too, so I can make up just as many reasons as you to pull it in.

> The difference here is that although I feel Alex's script is a
> pointless project, I'm in no way opposed to merging it in the tree if
> people use it and it solves their problem. Some people seem to be
> violently opposed to merging the KVM tool and I'm having difficult
> time understanding why that is.

It's a matter of size and scope. Write a shell script that clones, builds and executes KVM Tool and throw it in testing/tools/ and I'll happily ack it!


Alex

