Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab2IIUd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:33:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50203 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab2IIUdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:33:55 -0400
Message-ID: <504CFD22.3050300@zytor.com>
Date: Sun, 09 Sep 2012 13:33:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, linux-mm <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mtd: kernel BUG at arch/x86/mm/pat.c:279!
References: <1340959739.2936.28.camel@lappy>  <CA+1xoqdgKV_sEWvUbuxagL9JEc39ZFa6X9-acP7j-M7wvW6qbQ@mail.gmail.com>  <CA+55aFzJCLxVP+WYJM-gq=aXx5gmdgwC7=_Gr2Tooj8q+Dz4dw@mail.gmail.com>  <1347057778.26695.68.camel@sbsiddha-desk.sc.intel.com>  <CA+55aFwW9Q+DM2gZy7r3JQJbrbMNR6sN+jewc2CY0i1wD_X=Tw@mail.gmail.com>  <1347062045.26695.82.camel@sbsiddha-desk.sc.intel.com>  <CA+55aFzeKcV5hROLJE31dNi3SEs+s6o0LL=96Kh8QGHPx=aZnA@mail.gmail.com>  <504CCA31.2000003@zytor.com> <1347217472.2068.35.camel@shinybook.infradead.org>
In-Reply-To: <1347217472.2068.35.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 12:04 PM, David Woodhouse wrote:
> On Sun, 2012-09-09 at 09:56 -0700, H. Peter Anvin wrote:
>>
>>> So it should either be start=0xfffffffffffff000 end=0xffffffffffffffff
>>> or it should be start=0xfffffffffffff000 len=0x1000.
>>
>> I would strongly object to the former; that kind of inclusive ranges
>> breed a whole class of bugs by themselves.
>
> Another alternative that avoids overflow issues is to use a PFN rather
> than a byte address.
>

Except as a result of that logic have a bunch of places which either 
have rounding errors in how they calculate PFNs, or they think they can 
stick PFNs into 32-bit numbers.  :(

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

