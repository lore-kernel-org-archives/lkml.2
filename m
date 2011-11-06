Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab1KFP4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 10:56:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab1KFP4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 10:56:51 -0500
Message-ID: <4EB6AE34.2000907@redhat.com>
Date: Sun, 06 Nov 2011 17:56:36 +0200
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
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
In-Reply-To: <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 03:06 PM, Pekka Enberg wrote:
> On Sun, Nov 6, 2011 at 2:43 PM, Avi Kivity <avi@redhat.com> wrote:
> > You say that kvm-tool's scope is broader than Alex's script, therefore
> > the latter is pointless.
>
> I'm saying that Alex's script is pointless because it's not attempting
> to fix the real issues. For example, we're trying to make make it as
> easy as possible to setup a guest and to be able to access guest data
> from the host.

Have you tried virt-install/virt-manager?

> Alex's script is essentially just a simplified QEMU
> "front end" for kernel developers.

AFAIR it was based off a random Linus remark.

> That's why I feel it's a pointless thing to do.
>
> On Sun, Nov 6, 2011 at 2:43 PM, Avi Kivity <avi@redhat.com> wrote:
> > You accept that qemu's scope is broader than kvm-tool (and is a
> > superset).  That is why many people think kvm-tool is pointless.
>
> Sure. I think it's mostly people that are interested in non-Linux
> virtualization that think the KVM tool is a pointless project.
> However, some people (including myself) think the KVM tool is a more
> usable and hackable tool than QEMU for Linux virtualization.

More hackable, certainly, as any 20kloc project will be compared to a
700+kloc project with a long history.  More usable, I really doubt
this.  You take it for granted that people want to run their /boot
kernels in a guest, but in fact only kernel developers (and testers)
want this.  The majority want the real guest kernel.

> The difference here is that although I feel Alex's script is a
> pointless project, I'm in no way opposed to merging it in the tree if
> people use it and it solves their problem. Some people seem to be
> violently opposed to merging the KVM tool and I'm having difficult
> time understanding why that is.

One of the reasons is that if it is merge, anyone with a #include
<linux/foo.h> will line up for the next merge window, wanting in.  The
other is that anything in the Linux source tree might gain an unfair
advantage over out-of-tree projects (at least that's how I read Jan's
comment).

-- 
error compiling committee.c: too many arguments to function

