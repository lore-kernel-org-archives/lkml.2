Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab1KGMTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:19:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab1KGMTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:19:09 -0500
Message-ID: <4EB7CCA9.7010507@redhat.com>
Date: Mon, 07 Nov 2011 13:18:49 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Avi Kivity <avi@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de>	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>	<4EB65C5B.8070709@redhat.com>	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>	<4EB66036.4080102@redhat.com>	<1320577728.1428.73.camel@jaguar>	<4EB67486.1070105@redhat.com>	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>	<4EB67D17.7000701@redhat.com>	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>	<4EB680D9.2070706@redhat.com>	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>	<877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>	<CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>	<4EB7B1A9.9000409@redhat.com>	<CA+1xoqfXq++t9YzqDQH60oLDkWhyvEJsC6QWJ1gx8ikQA=eAhQ@mail.gmail.com>	<4EB7BACA.70006@redhat.com> <CAOJsxLGFjfQwGJjcCnj_0dos=_BM_5AaZ6NkMEbYDGVgPaHOJA@mail.gmail.com>
In-Reply-To: <CAOJsxLGFjfQwGJjcCnj_0dos=_BM_5AaZ6NkMEbYDGVgPaHOJA@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/11 12:44, Pekka Enberg wrote:
> On Mon, Nov 7, 2011 at 1:02 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> Indeed I do not see any advantage, since all the interfaces they use are
>> stable anyway (sysfs, msr.ko).
>>
>> If they had gone in x86info, for example, my distro (F16, not exactly
>> conservative) would have likely picked those tools up already, but it
>> didn't.
> 
> Distributing userspace tools in the kernel tree is a relatively new
> concept so it's not at all surprising distributions don't pick them up
> as quickly. That doesn't mean it's a fundamentally flawed approach,
> though.

tools/ lacks a separation into "kernel hacker's testing+debugging
toolbox" and "userspace tools".  It lacks proper buildsystem integration
for the userspace tools, there is no "make tools" and also no "make
tools_install".  Silently dropping new stuff into tools/ and expecting
the world magically noticing isn't going to work.

cheers,
  Gerd
