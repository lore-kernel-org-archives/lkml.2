Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab2DKDK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 23:10:26 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35594 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756018Ab2DKDKY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 23:10:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAMjpGUetfGQxqTKVfLBtOdthxFtFv-knuXSWoNx0BKxJd=829Q@mail.gmail.com>
References: <20120410224543.GA11433@windriver.com> <CAMjpGUetfGQxqTKVfLBtOdthxFtFv-knuXSWoNx0BKxJd=829Q@mail.gmail.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 10 Apr 2012 23:09:51 -0400
X-Google-Sender-Auth: SpEpRNGYEHWZkng8GrSHRFWNIIM
Message-ID: <CAP=VYLrzvXCTD4J3sdhMCjnsPKvf-tobkE0G6OgTvc4mnEiw7A@mail.gmail.com>
Subject: Re: linux-next: triage for April 10, 2012
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 10:50 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Tue, Apr 10, 2012 at 18:45, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> bfin: 50% of builds
>>        when:   Mar 31
>>        why:    "Error: pcrel too far BFD_RELOC_BFIN_10" from kernel/time/timekeeping.c
>>        status: unknown, binutils issue?
>>        fix:
>>        ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5981475/
>
> that log file doesn't say anything about "BFD_RELOC_BFIN_10"

Thanks Mike, I'll fix the stale link.  Here is a RELOC_BFIN_10 fail:

http://kisskb.ellerman.id.au/kisskb/buildresult/6087324/

Looks like I should go over the bfin fails and check each one, since
they are somewhat unique -- e.g.

arch/blackfin/mach-bf537/boards/dnp5370.c:392:17: error:
'bfin_spi_board_info' undeclared (first use in this function)

in DNP5370_defconfig

and

arch/blackfin/mach-bf533/boards/ip0x.c:299:26: error:
'bfin_spi_board_info' undeclared (first use in this function)

in IP0X_defconfig

http://kisskb.ellerman.id.au/kisskb/buildresult/6087345/

are not related to the RELOC_BFIN_10

Paul.
--

>
> it does show the old L1 data overflow though ...
>
> on a side note, the warning:
> arch/blackfin/mm/init.c:79:9: warning: array subscript is above array
> bounds [-Warray-bounds]
> is a bad thing, but i've just pushed a fix for that ...
> -mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
