Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab0HPBgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 21:36:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891Ab0HPBgN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 21:36:13 -0400
MIME-Version: 1.0
In-Reply-To: <20100815182153.994179c1.akpm@linux-foundation.org>
References: <AANLkTikV2eVo6KM5dSqfDwAwT=bVxnuWSpBE7F+JQU+_@mail.gmail.com>
 <AANLkTi=vngT_5XYz1=3P6GjExFNtCVCdBMhaz4Sc4oEk@mail.gmail.com>
 <20100815133015.883c7069.akpm@linux-foundation.org> <AANLkTi=Ok3NH3k5EF1Da2Z3xA7uahABRtH7pEdOEuZH2@mail.gmail.com>
 <20100815182153.994179c1.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Aug 2010 18:35:22 -0700
Message-ID: <AANLkTinBAgk_Ay4vCcTxTEsq-uwn=RwQpTA6O86JXGCM@mail.gmail.com>
Subject: Re: [git pull request] ACPI patches for 2.6.36.merge
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sedat.dilek@gmail.com, Andi Kleen <ak@linux.intel.com>,
        len.brown@intel.com, Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 6:21 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> The patch I sent Len patched acpi_power_seq_show().
>
>> What does that say about the _rest_ of the patches?
>
> Not tested in combination?

Not tested at all. They were apparently just applied from some other
source. And not even safely, but with "they can apply with fuzz",
which is downright dangerous. And then the result saw neither a
compiler nor a boot.

>> What does that say about (lack of) -next testing?
>
> That code compiled OK in -mm which includes linux-next.  I assume that
> some last-minute merging broke things.

There are _zero_ merge errors there. Go take a look at Len's tree.
It's a linear progression of patches AND THE PATCH IN LEN'S TREE IS
BUGGY.

It's that simple. It clearly never ever saw -next, because it _cannot_
have seen next. That particular commit can never have compiled.

Now, if you sent a patch that touched acpi_power_seq_show(), then the
error happened at Len's side. He took a patch, applied it with fuzz at
the wrong place, and sent the result to me without ever even compiling
it. And that doesn't make me happy.

I decided I should probably pull anyway, because at least the reason
for the bug was explained. And I want to get -rc1 out today. But I'm
grumbling, and judging from your emails, you didn't even look at what
Len sent me. There really are _no_ excuses.

                       Linus
