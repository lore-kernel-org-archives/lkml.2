Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756Ab2FGLMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 07:12:51 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:22871 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759492Ab2FGLMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 07:12:50 -0400
Message-ID: <4FD08C1B.1090107@snapgear.com>
Date: Thu, 7 Jun 2012 21:10:19 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Philippe De Muyter <phdm@macqel.be>, Greg Ungerer <gerg@uclinux.org>,
        <linux-m68k@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(),
 and strnlen_user()
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org> <20120530102226.GA28628@frolo.macqel> <CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com> <20120530140444.GA10543@frolo.macqel> <CAMuHMdW29QYN6XpBb9F3GGoJ-9frrD-00Wx=FchT9ALqW1LcPg@mail.gmail.com> <4FCEF956.9090603@snapgear.com> <CAMuHMdWg6W4uOm3N-etXJud5Lw-vBkstQ2h7HK=6i+sCLgeksQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWg6W4uOm3N-etXJud5Lw-vBkstQ2h7HK=6i+sCLgeksQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 06/07/2012 03:46 AM, Geert Uytterhoeven wrote:
> On Wed, Jun 6, 2012 at 8:31 AM, Greg Ungerer<gerg@snapgear.com>  wrote:
>> Yes, looks like that should have a "|| defined(CONFIG_CPU32)".
>> (According to the CPU32 reference manual words and long words must
>> be aligned on word boundaries.)
>>
>> I think something like CONFIG_CPU_HAS_NO_UNALIGNED makes sense.
>
> OK, doing that now...
>
> Then I saw arch/m68k/lib/memcpy.c.
>
> commit f230e80b423f6cb002015ab4771c06a53d5a2287
> ("m68k: fix memcpy to unmatched/unaligned source and dest on 68000")
>
> | The original 68000 processors cannot copy 16bit or larger quantities from
> | odd addresses. All newer members of the 68k family (including ColdFire)
> | can do this.
>
> So all Coldfires can do unaligned _reads_, but not unaligned _writes_
> (exceptions below)?

This strikes me as odd. Maybe this has been wrong all along. I need
to check further but in a little testing I did today I think it may
well be that all ColdFire support unaligned reads and writes.


>>>> I also think that the Coldfire 5272 can do unaligned accesses, but I
>>>> cannot test that at the moment.
>>
>>
>> According to the MCF5272 User Manual, "it supports misaligned data
>> accesses ...". So it looks like it does.
>>
>> Having a CONFIG_CPU_HAS_NO_UNALIGNED looks like a really good solution
>> then. We need to be able select it as required on individual CPU types.
>
> For now, I just make COLDFIRE select it, but we can move it to the individual
> CPU types later.

No matter what I find I still think this is the way to go.

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
