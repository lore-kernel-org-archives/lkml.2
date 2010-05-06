Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab0EFBYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 21:24:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51030 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0EFBYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 21:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TORaDhX6gIB+LUtdt+SVqbFPgta3ebN2YbuVkhlR6y88yNc1mvyUYl/e6RhwGcSm+z
         rj277yy/mnFhuFLfMNmyJQdN4O2eIxwJ9+5pvdwHkZK21PsqgH8buuJFrkcbJqp3aMPV
         Lha941XUGoXNn40+I9X/6/rOIXQoZNa3AEc+c=
MIME-Version: 1.0
In-Reply-To: <4BE14335.10702@ru.mvista.com>
References: <k2ncecb6d8f1004191627w3cd36450xf797f746460abb09@mail.gmail.com>
	 <20100420155122.6f2c26eb.akpm@linux-foundation.org>
	 <20100420230719.GB1432@n2100.arm.linux.org.uk>
	 <4BE14335.10702@ru.mvista.com>
Date: Thu, 6 May 2010 10:24:06 +0900
X-Google-Sender-Auth: 467a1779f6601799
Message-ID: <p2g9c9fda241005051824k54e70136v8324d135b44c71b5@mail.gmail.com>
Subject: Re: Suspicious compilation warning
From: Kyungmin Park <kmpark@infradead.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 7:06 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> Russell King - ARM Linux wrote:
>
>>>> I get this warning while compiling for ARM/SA1100:
>>>>
>>>> mm/sparse.c: In function '__section_nr':
>>>> mm/sparse.c:135: warning: 'root' is used uninitialized in this function
>>>>
>>>> With a small patch in fs/proc/meminfo.c, I find that NR_SECTION_ROOTS
>>>> is zero, which certainly explains the warning.
>>>>
>>>> # cat /proc/meminfo
>>>> NR_SECTION_ROOTS=0
>>>> NR_MEM_SECTIONS=32
>>>> SECTIONS_PER_ROOT=512
>>>> SECTIONS_SHIFT=5
>>>> MAX_PHYSMEM_BITS=32
>>>>
>>>
>>> hm, who owns sparsemem nowadays? Nobody identifiable.
>>>
>>> Does it make physical sense to have SECTIONS_PER_ROOT > NR_MEM_SECTIONS?
>>>
>>
>> Well, it'll be about this number on everything using sparsemem extreme:
>>
>> #define SECTIONS_PER_ROOT       (PAGE_SIZE / sizeof (struct mem_section))
>>
>> and with only 32 sections, this is going to give a NR_SECTION_ROOTS value
>> of zero.  I think the calculation of NR_SECTIONS_ROOTS is wrong.
>>
>> #define NR_SECTION_ROOTS        (NR_MEM_SECTIONS / SECTIONS_PER_ROOT)
>>
>> Clearly if we have 1 mem section, we want to have one section root, so
>> I think this division should round up any fractional part, thusly:
>>
>> #define NR_SECTION_ROOTS        ((NR_MEM_SECTIONS + SECTIONS_PER_ROOT - 1)
>> / SECTIONS_PER_ROOT)
>>
>
>  There's DIV_ROUND_UP() macro for this kind of calculation.

Hi,

It tested with my board and working.
Just curious. If NR_SECTION_ROOTS is zero and uninitialized then
what's problem? Since we boot and working without patch.

Thank you,
Kyungmin Park
