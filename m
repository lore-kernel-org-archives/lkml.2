Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1KFUBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 15:01:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52946 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1KFUBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 15:01:30 -0500
Message-ID: <4EB6E798.3060000@redhat.com>
Date: Sun, 06 Nov 2011 21:01:28 +0100
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
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de> <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com> <4EB6DBC6.2010404@redhat.com> <CAOJsxLGzMqQDwfm8C-6g8SCapEmGs7uUPq+SuL946yg=anV85g@mail.gmail.com>
In-Reply-To: <CAOJsxLGzMqQDwfm8C-6g8SCapEmGs7uUPq+SuL946yg=anV85g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 08:17 PM, Pekka Enberg wrote:
>> >  But I'm pretty certain that, when testing 3.2 with KVM tool in a couple of
>> >  years, I want all the shining new features you added in this time; I don't
>> >  want the old end-2011 code.  Same if I'm bisecting kernels, I don't want to
>> >  build KVM tool once per bisection cycle, do I?
>
> If you're bisecting breakage that can be in the guest kernel or the
> KVM tool, you'd want to build both.

No.  I want to try new tool/old kernel and old tool/new kernel (kernel 
can be either guest or host, depending on the nature of the bug), and 
then bisect just one.  (*) And that's the exceptional case, and only KVM 
tool developers really should have the need to do that.

   (*) Not coincidentially, that's what git bisect does when HEAD is
       a merge of two unrelated histories.

> What would prevent you from using a newer KVM tool with an older kernel?

Nothing, but I'm just giving you *strong* hints that a submodule or a 
merged tool is the wrong solution, and the histories of kernel and tool 
should be kept separate.

More clearly: for its supposedly intended usage, namely testing 
development kernels in a *guest*, KVM tool will generally not run on the 
exact *host* kernel that is in the tree it lives with.  Almost never, in 
fact.  Unlike perf, if you want to test multiple guest kernels you 
should never need to rebuild KVM tool!

This is the main argument as to whether or not to merge the tool.  Would 
the integration of the *build* make sense or not?  Assume you adapt the 
ktest script to make both the KVM tool and the kernel, and test the 
latter using the former.  Your host kernel never changes, and yet you 
introduce a new variable in your testing.  That complicates things, it 
doesn't simplify them.

Paolo
