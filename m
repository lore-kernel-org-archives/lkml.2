Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2IXQdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:33:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41341 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2IXQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:33:41 -0400
MIME-Version: 1.0
In-Reply-To: <1348502863.11847.92.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic> <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com> <1348502863.11847.92.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Sep 2012 09:33:20 -0700
X-Google-Sender-Auth: drEp-97iknNvofX39S6Dv6Fzgbo
Message-ID: <CA+55aFxtQXmqeo5uNNgy+GLDWbQ5e+cqqc5-qnjds=P-VSCOsQ@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mgorman@suse.de>, Borislav Petkov <bp@alien8.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 9:07 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2012-09-24 at 08:52 -0700, Linus Torvalds wrote:
>> Your patch looks odd, though. Why do you use some complex initial
>> value for 'candidate' (nr_cpu_ids) instead of a simple and readable
>> one (-1)?
>
> nr_cpu_ids is the typical no-value value for cpumask operations -- yes
> this is annoying and I keep doing it wrong far too often.

Can we please just fix it? Making the excuse that it's the "typical
no-value" is still stupid, because it's a f*cking moronic no-value.

Whoever thinks that it's smart to test against "nr_cpu_ids" when
there's a much more natural value (-1) is crazy. The source code looks
more complex, but the code it *generates* is clearly more complex and
worse too.

Sure, the "scan bits" bitops will return ">= nr_cpu_ids" for the "I
couldn't find a bit" thing, but that doesn't mean that everything else
should.

            Linus
