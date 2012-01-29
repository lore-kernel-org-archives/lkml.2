Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2A2ICu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 03:02:50 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59877 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508Ab2A2ICt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 03:02:49 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
References: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
	<CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
	<20120121082857.GC32134@elte.hu>
	<CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
	<20120121165830.GA9216@elte.hu>
	<CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
	<CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
Date: Sun, 29 Jan 2012 17:02:49 +0900
Message-ID: <CAMO-S2iRT+uRzzsQRmhhCs4WRefsfFirteeKXtgX3h+kuWi+eQ@mail.gmail.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 01:57, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 23, 2012 at 8:05 AM, Hitoshi Mitake <h.mitake@gmail.com> wrote:
>>
>> I wrote the patch which adds the new file include/asm-generic/io-nonatomic.h.
>> io-nonatomic.h provides non-atomic version readq()/writeq().
>
> I do wonder if we should do "little-endian" and "big-endian" variations?

Thanks, I'll prepare two variations based on CPU_LITTLE_ENDIAN.

>
> Quoting Willy:
>
>  "For this particular hardware, it's defined to work if you read the
> low order bits first"
>
> so I think we need make that explicit, and make two include files:
>
>   include/asm-generic/io-64b-lo-hi.h
>   include/asm-generic/io-64b-hi-lo.h
>
> or something like that. And thus indirectly document these kinds of
> requirements.
>
> Hmm?
>
>                Linus

I have a question about the order of readl/writel.
If the non-atomic readq/writeq is placed under asm-generic/,
they will be used by every architecture.

I don't know about the minor architectures, but some of them,
like alpha, seems to do reordering of memory access agressively.

Is the reordering is applied to io rw?
Should memory barriers be placed between two readl/writel?

-- 
Hitoshi Mitake
h.mitake@gmail.com
