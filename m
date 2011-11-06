Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1KFQfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 11:35:33 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41192 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1KFQfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 11:35:32 -0500
MIME-Version: 1.0
In-Reply-To: <4EB6AE34.2000907@redhat.com>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	<4EB65C5B.8070709@redhat.com>
	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	<4EB66036.4080102@redhat.com>
	<1320577728.1428.73.camel@jaguar>
	<4EB67486.1070105@redhat.com>
	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
	<4EB67D17.7000701@redhat.com>
	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<4EB6AE34.2000907@redhat.com>
Date: Sun, 6 Nov 2011 18:35:31 +0200
X-Google-Sender-Auth: uqFGTX0zqckoznwWtdzjlJo_qrk
Message-ID: <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Sun, Nov 6, 2011 at 5:56 PM, Avi Kivity <avi@redhat.com> wrote:
> On 11/06/2011 03:06 PM, Pekka Enberg wrote:
>> On Sun, Nov 6, 2011 at 2:43 PM, Avi Kivity <avi@redhat.com> wrote:
>> > You say that kvm-tool's scope is broader than Alex's script, therefore
>> > the latter is pointless.
>>
>> I'm saying that Alex's script is pointless because it's not attempting
>> to fix the real issues. For example, we're trying to make make it as
>> easy as possible to setup a guest and to be able to access guest data
>> from the host.
>
> Have you tried virt-install/virt-manager?

No, I don't use virtio-manager. I know a lot of people do which is why
someone is working on KVM tool libvirt integration.

>> On Sun, Nov 6, 2011 at 2:43 PM, Avi Kivity <avi@redhat.com> wrote:
>> > You accept that qemu's scope is broader than kvm-tool (and is a
>> > superset).  That is why many people think kvm-tool is pointless.
>>
>> Sure. I think it's mostly people that are interested in non-Linux
>> virtualization that think the KVM tool is a pointless project.
>> However, some people (including myself) think the KVM tool is a more
>> usable and hackable tool than QEMU for Linux virtualization.
>
> More hackable, certainly, as any 20kloc project will be compared to a
> 700+kloc project with a long history.  More usable, I really doubt
> this.  You take it for granted that people want to run their /boot
> kernels in a guest, but in fact only kernel developers (and testers)
> want this.  The majority want the real guest kernel.

Our inability to boot ISO images, for example, is a usability
limitation, sure. I'm hoping to fix that at some point.

>> The difference here is that although I feel Alex's script is a
>> pointless project, I'm in no way opposed to merging it in the tree if
>> people use it and it solves their problem. Some people seem to be
>> violently opposed to merging the KVM tool and I'm having difficult
>> time understanding why that is.
>
> One of the reasons is that if it is merge, anyone with a #include
> <linux/foo.h> will line up for the next merge window, wanting in.  The
> other is that anything in the Linux source tree might gain an unfair
> advantage over out-of-tree projects (at least that's how I read Jan's
> comment).

Well, having gone through the process of getting something included so
far, I'm not at all worried that there's going to be a huge queue of
"#include <linux/foo.h>" projects if we get in...

What kind of unfair advantage are you referring to? I've specifically
said that the only way for KVM tool to become a reference
implementation would be that the KVM maintainers take the tool through
their tree. As that's not going to happen, I don't see what the
problem would be.

                                 Pekka
