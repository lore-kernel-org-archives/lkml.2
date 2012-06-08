Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2FHEPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:15:34 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:61018 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2FHEPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:15:33 -0400
Message-ID: <4FD17C08.8030203@snapgear.com>
Date: Fri, 8 Jun 2012 14:14:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Philippe De Muyter <phdm@macqel.be>, Greg Ungerer <gerg@uclinux.org>,
        <linux-m68k@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(),
 and strnlen_user()
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org> <20120530102226.GA28628@frolo.macqel> <CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com> <20120530140444.GA10543@frolo.macqel> <CAMuHMdW29QYN6XpBb9F3GGoJ-9frrD-00Wx=FchT9ALqW1LcPg@mail.gmail.com> <4FCEF956.9090603@snapgear.com> <CAMuHMdWg6W4uOm3N-etXJud5Lw-vBkstQ2h7HK=6i+sCLgeksQ@mail.gmail.com> <4FD08C1B.1090107@snapgear.com> <m2bokvw9f1.fsf@igel.home>
In-Reply-To: <m2bokvw9f1.fsf@igel.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/12 23:14, Andreas Schwab wrote:
> Greg Ungerer<gerg@snapgear.com>  writes:
>
>> This strikes me as odd. Maybe this has been wrong all along. I need
>> to check further but in a little testing I did today I think it may
>> well be that all ColdFire support unaligned reads and writes.
>
> The CFPRM doesn't indicate otherwise (the address error exception is
> only documented to be raised for a word index addressing mode).

Yeah, I can't find anything that says otherwise in any of the CPU
specific data sheets either. I suspect the internals of unaligned.h
have just been carried from the original non-mmu 68k support to
ColdFire.

Testing on the ColdFires I have at hand here shows unaligned reads
and writes working on all. And that includes testing with a modified
unaligned.h that allows unaligned accesses.

Geert, I'll put a patch together that changes this over. I'll make
that on top of your recent patch series.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
