Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2IIQ5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 12:57:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49033 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab2IIQ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 12:57:05 -0400
Message-ID: <504CCA31.2000003@zytor.com>
Date: Sun, 09 Sep 2012 09:56:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, linux-mm <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mtd: kernel BUG at arch/x86/mm/pat.c:279!
References: <1340959739.2936.28.camel@lappy> <CA+1xoqdgKV_sEWvUbuxagL9JEc39ZFa6X9-acP7j-M7wvW6qbQ@mail.gmail.com> <CA+55aFzJCLxVP+WYJM-gq=aXx5gmdgwC7=_Gr2Tooj8q+Dz4dw@mail.gmail.com> <1347057778.26695.68.camel@sbsiddha-desk.sc.intel.com> <CA+55aFwW9Q+DM2gZy7r3JQJbrbMNR6sN+jewc2CY0i1wD_X=Tw@mail.gmail.com> <1347062045.26695.82.camel@sbsiddha-desk.sc.intel.com> <CA+55aFzeKcV5hROLJE31dNi3SEs+s6o0LL=96Kh8QGHPx=aZnA@mail.gmail.com>
In-Reply-To: <CA+55aFzeKcV5hROLJE31dNi3SEs+s6o0LL=96Kh8QGHPx=aZnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2012 12:57 PM, Linus Torvalds wrote:
>
> Ack.
>
> Anyway, that means that the BUG_ON() is likely bogus, but so is the
> whole calling convention.
>
> The 4kB range starting at 0xfffffffffffff000 sounds like a *valid*
> range, but that requires that we fix the calling convention to not
> have that "end" (exclusive) thing. It should either be "end"
> (inclusive), or just "len".
>

On x86, it is definitely NOT a valid range.  There is no physical 
addresses there, and there will never be any.

> So it should either be start=0xfffffffffffff000 end=0xffffffffffffffff
> or it should be start=0xfffffffffffff000 len=0x1000.

I would strongly object to the former; that kind of inclusive ranges 
breed a whole class of bugs by themselves.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

