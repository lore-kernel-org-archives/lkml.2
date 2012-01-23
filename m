Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2AWXEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:04:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:27483 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab2AWXE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:04:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="59296478"
Message-ID: <4F1DE77B.50004@linux.intel.com>
Date: Mon, 23 Jan 2012 15:04:27 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        linux-kernel@vger.kernel.org, linux-nvme@infradead.org
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
References: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com> <CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com> <20120121082857.GC32134@elte.hu> <CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com> <20120121165830.GA9216@elte.hu> <CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com> <CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
In-Reply-To: <CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 08:57 AM, Linus Torvalds wrote:
> On Mon, Jan 23, 2012 at 8:05 AM, Hitoshi Mitake<h.mitake@gmail.com>  wrote:
>>
>> I wrote the patch which adds the new file include/asm-generic/io-nonatomic.h.
>> io-nonatomic.h provides non-atomic version readq()/writeq().
>
> I do wonder if we should do "little-endian" and "big-endian" variations?
>
> Quoting Willy:
>
>    "For this particular hardware, it's defined to work if you read the
> low order bits first"
>
> so I think we need make that explicit, and make two include files:
>
>     include/asm-generic/io-64b-lo-hi.h
>     include/asm-generic/io-64b-hi-lo.h
>
> or something like that. And thus indirectly document these kinds of
> requirements.
>

I would concur with this (and I have suggested exactly this in the past.)

	-hpa

