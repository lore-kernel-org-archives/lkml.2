Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1KFURt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 15:17:49 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40115 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KFURs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 15:17:48 -0500
MIME-Version: 1.0
In-Reply-To: <4EB6E798.3060000@redhat.com>
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
	<877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
	<CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
	<4EB6DBC6.2010404@redhat.com>
	<CAOJsxLGzMqQDwfm8C-6g8SCapEmGs7uUPq+SuL946yg=anV85g@mail.gmail.com>
	<4EB6E798.3060000@redhat.com>
Date: Sun, 6 Nov 2011 22:17:47 +0200
X-Google-Sender-Auth: Ah4jeBMfDhuKJwbWKhhbC61fzNY
Message-ID: <CAOJsxLF6bOPJk+atASGr_Ra3BfwbkGPfGb2iRCOrfpFODBc-jA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <agraf@suse.de>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Blue Swirl <blauwirbel@gmail.com>, Avi Kivity <avi@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 10:01 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> If you're bisecting breakage that can be in the guest kernel or the
>> KVM tool, you'd want to build both.
>
> No.  I want to try new tool/old kernel and old tool/new kernel (kernel can
> be either guest or host, depending on the nature of the bug), and then
> bisect just one.  (*) And that's the exceptional case, and only KVM tool
> developers really should have the need to do that.

Exactly - having the source code in Linux kernel tree covers the
"exceptional case" where we're unsure which part of the equation broke
things (which are btw the nasties issues we've had so far). I have no
idea why you're trying to convince me that it doesn't matter. You can
bisect only one of the components in isolation just fine.

On Sun, Nov 6, 2011 at 10:01 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> What would prevent you from using a newer KVM tool with an older kernel?
>
> Nothing, but I'm just giving you *strong* hints that a submodule or a merged
> tool is the wrong solution, and the histories of kernel and tool should be
> kept separate.
>
> More clearly: for its supposedly intended usage, namely testing development
> kernels in a *guest*, KVM tool will generally not run on the exact *host*
> kernel that is in the tree it lives with.  Almost never, in fact.  Unlike
> perf, if you want to test multiple guest kernels you should never need to
> rebuild KVM tool!
>
> This is the main argument as to whether or not to merge the tool.  Would the
> integration of the *build* make sense or not?  Assume you adapt the ktest
> script to make both the KVM tool and the kernel, and test the latter using
> the former.  Your host kernel never changes, and yet you introduce a new
> variable in your testing.  That complicates things, it doesn't simplify
> them.

I don't understand what trying to say. There's no requirement to build
the KVM tool if you're bisecting a guest kernel.

                        Pekka
