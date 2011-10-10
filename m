Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1JJTvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:51:33 -0400
Received: from claw.goop.org ([74.207.240.146]:41544 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab1JJTvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:51:32 -0400
Message-ID: <4E934CC1.9040804@goop.org>
Date: Mon, 10 Oct 2011 12:51:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@suse.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        the arch/x86 maintainers <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <201109282008.17722.stephan.diestelhorst@amd.com> <CA+55aFwm7ESNfrHhEHrAKcjcPUq8YxtuEkJd5PzAekYo2dMYNw@mail.gmail.com> <2707952.s3VYcmPHUN@chlor> <4E8DE7F1.3050108@goop.org> <4E8DEED0.1020909@goop.org> <20111010073214.GB29035@elte.hu>
In-Reply-To: <20111010073214.GB29035@elte.hu>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 12:32 AM, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> On 10/06/2011 10:40 AM, Jeremy Fitzhardinge wrote:
>>> However, it looks like locked xadd is also has better performance:  on
>>> my Sandybridge laptop (2 cores, 4 threads), the add+mfence is 20% slower
>>> than locked xadd, so that pretty much settles it unless you think
>>> there'd be a dramatic difference on an AMD system.
>> Konrad measures add+mfence is about 65% slower on AMD Phenom as well.
> xadd also results in smaller/tighter code, right?

Not particularly, mostly because of the overflow-into-the-high-part
compensation.  But its only a couple of extra instructions, and no
conditionals, so I don't think it would have any concrete effect.

But, as Stephen points out, perhaps locked add is preferable to locked
xadd, since it also has the same barrier as mfence but has
(significantly!) better performance than either mfence or locked xadd...

    J
