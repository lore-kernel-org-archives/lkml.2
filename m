Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab1KGIAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 03:00:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1KGIAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 03:00:33 -0500
Message-ID: <4EB79000.5040308@redhat.com>
Date: Mon, 07 Nov 2011 09:00:00 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Alexander Graf <agraf@suse.de>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Blue Swirl <blauwirbel@gmail.com>, Avi Kivity <avi@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de> <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com> <4EB6DBC6.2010404@redhat.com> <CAOJsxLGzMqQDwfm8C-6g8SCapEmGs7uUPq+SuL946yg=anV85g@mail.gmail.com> <4EB6E798.3060000@redhat.com> <CAOJsxLF6bOPJk+atASGr_Ra3BfwbkGPfGb2iRCOrfpFODBc-jA@mail.gmail.com>
In-Reply-To: <CAOJsxLF6bOPJk+atASGr_Ra3BfwbkGPfGb2iRCOrfpFODBc-jA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 09:17 PM, Pekka Enberg wrote:
> >  No.  I want to try new tool/old kernel and old tool/new kernel (kernel can
> >  be either guest or host, depending on the nature of the bug), and then
> >  bisect just one.  (*) And that's the exceptional case, and only KVM tool
> >  developers really should have the need to do that.
>
> Exactly - having the source code in Linux kernel tree covers the
> "exceptional case" where we're unsure which part of the equation broke
> things (which are btw the nasties issues we've had so far).

No, having the source code in Linux kernel tree is perfectly useless for 
the exceptional case, and forces you to go through extra hoops to build 
only one component.  Small hoops such as adding "-- tools/kvm" to "git 
bisect start" perhaps, but still hoops that aren't traded for a 
practical advantage.  You keep saying "oh things have been so much 
better" because "it's so close to the kernel" and "it worked so great 
for perf", but you haven't brought any practical example that we can 
stare at in admiration.

(BTW, I'm also convinced like Ted that not having a defined perf ABI 
might have made sense in the beginning, but it has now devolved into bad 
software engineering practice).

> I have no idea why you're trying to convince me that it doesn't matter.

I'm not trying to convince you that it doesn't matter, I'm trying to 
convince you that it doesn't *make sense*.

> It's a hypervisor that implements virtio drivers, serial
> emulation, and mini-BIOS.

... all of which have a spec against which you should be working.  Save 
perhaps for the mini-BIOS, if you develop against the kernel source 
rather than the spec you're doing it *wrong*.  Very wrong.  But you've 
been told this many times already.

Paolo
