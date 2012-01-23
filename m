Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2AWQ5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:57:34 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43508 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2AWQ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:57:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
References: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
 <CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
 <20120121082857.GC32134@elte.hu> <CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
 <20120121165830.GA9216@elte.hu> <CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 08:57:10 -0800
X-Google-Sender-Auth: NFuARXcq07VvIj-W1a4JnD75H4g
Message-ID: <CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        linux-kernel@vger.kernel.org, linux-nvme@infradead.org,
        hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 8:05 AM, Hitoshi Mitake <h.mitake@gmail.com> wrote:
>
> I wrote the patch which adds the new file include/asm-generic/io-nonatomic.h.
> io-nonatomic.h provides non-atomic version readq()/writeq().

I do wonder if we should do "little-endian" and "big-endian" variations?

Quoting Willy:

  "For this particular hardware, it's defined to work if you read the
low order bits first"

so I think we need make that explicit, and make two include files:

   include/asm-generic/io-64b-lo-hi.h
   include/asm-generic/io-64b-hi-lo.h

or something like that. And thus indirectly document these kinds of
requirements.

Hmm?

                Linus
