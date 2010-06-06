Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0FFIRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 04:17:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49000 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0FFIRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 04:17:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OAlM3tjCleh202qZB6FTh+mCwhZ/xPecHf87Y91j6ObjEWkEgZOhznSpLeT249Mo7e
         LUNGVE8ge02TiiLy7MIF1RiuwDkf8VsfV2NqpdlQP9un4O0463cAFpEHYdSH6KQnwoV8
         DCVlJIRYz8pKWF3PJIOt8RwN3R0pk4jev5iSs=
MIME-Version: 1.0
In-Reply-To: <201006051919.17738.marek.vasut@gmail.com>
References: <1275371058.7001.35.camel@balakrishnan-desktop> 
	<201006051919.17738.marek.vasut@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 6 Jun 2010 16:17:00 +0800
Message-ID: <AANLkTil5TWYILcdp872as8S8LMqQWhPYWLt7cxs2lUm5@mail.gmail.com>
Subject: Re: pxa300 - DDRAM base value
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       balakrishnan <balakrishnan@e-consystems.com>,
       linux-kernel@vger.kernel.org, Maharajan <maharajan@e-consystems.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 1:19 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
> Dne Út 1. června 2010 07:44:18 balakrishnan napsal(a):
>> I am working on pxa300 based development board and using Linux 2.6.34.
>> This Linux kernel already has support for following boards
>> 1. zylonite_pxa300
>> 2. cm-x300
>> 3. colibri-pxa300
>> 4. littleton
>>
>> My doubt is that pxa300 based boards are using "0xa0000000"  as DDRAM
>> base and PHYS_OFFSET is also defined in
>> "arch/arm/mach-pxa/include/mach/memory.h" as 0xa0000000.
>> But in our board  DDR is mapped in 0x80000000. Does it make any
>> problem?. Because after mmu is turned ON, my board is hanging.
>>
>> "zreladdr-y   := 0x80008000" is defined in
>> "arch/arm/mach-pxa/Makefile.boot" file .
>> my machine_desc is as follows
>> .phys_io        = 0x40000000,
>> .io_pg_offst    = (io_p2v(0x40000000) >> 18) & 0xfffc,
>> .boot_params    = 0x80000100,
>>
>
> Try editing both arch/arm/mach-pxa/Makefile.boot and
> arch/arm/mach/pxa/include/mach/memory.h
>
>> With Thanks
>> J.Balakrishnan
>
> The 0x80000000 should be aliased to 0xa0000000, but looking into the PXA docs,
> it is only on pxa320. Eric, any ideas on this ?
>

Should be working on pxa300/310 as well. If it doesn't, check you bootloader
to make sure the mapping is OK, and memory doesn't exceed
(0xa000_0000 - 0x8000_0000).
