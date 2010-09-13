Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0IMMsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:48:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51881 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab0IMMsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bccaOs04t5IpHA+V6f1lz/amCVs25MXomYwwYZumBw/PCq5S/jKaiLnyPWVC8bg24m
         YQ8Plkhbhl7HMaumjI5kGq/Ey1eTU5vuUOsqfRx+KJPiDG+jWsxMLjj2uuU/XQYg36kr
         URnFHMT3O3pdfxSHcL1XcWIHeIyfPIo4h33LA=
MIME-Version: 1.0
In-Reply-To: <20100913124049.GG30787@n2100.arm.linux.org.uk>
References: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com>
	<4C8E1417.4060204@compulab.co.il>
	<20100913124049.GG30787@n2100.arm.linux.org.uk>
Date: Mon, 13 Sep 2010 14:48:18 +0200
Message-ID: <AANLkTi=dT1uMrRctB4=Hvh35zVc-DtReWmHj-18cd9XT@mail.gmail.com>
Subject: Re: ARM target not boot after remap memory
From: Robin Theunis <robint91@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Yes I have tested it. I made a breakpoint at 0x2008000 and viewed that
the r1 register and there in I found the correct ID.

Robin

2010/9/13 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Mon, Sep 13, 2010 at 02:07:51PM +0200, Mike Rapoport wrote:
>> (add LAKLM to CC)
>
>>> The problem is now when linux kernel is booting, nothing happens.
>>>
>>> ---
>>> U-Boot> bootm
>>> ## Booting kernel from Legacy Image at 21000000 ...
>>>    Image Name:   Linux-2.6.34.1robin9200v1.0
>>>    Image Type:   ARM Linux Kernel Image (uncompressed)
>>>    Data Size:    1811796 Bytes = 1.7 MiB
>>>    Load Address: 20008000
>>>    Entry Point:  20008000
>>>    Verifying Checksum ... OK
>>>    Loading Kernel Image ... OK
>>> OK
>>>
>>> Starting kernel ...
>>>
>>> Uncompressing Linux... done, booting the kernel.
>>> ---
>>>
>>> Here is stalls. With my jtag probe I can locate the problem.
>>>
>>> ---
>>>> halt
>>> target state: halted
>>> target halted in ARM state due to debug-request, current mode: Supervisor
>>> cpsr: 0x600000d3 pc: 0xc000af3c
>>> MMU: enabled, D-Cache: enabled, I-Cache: enabled
>>>>   arm disassemble 0xc000af3c
>>> 0xc000af3c   0xeafffffe      B 0xc000af3c
>
> Probably __error.  Either your machine isn't supported, or the kernel
> doesn't recognise your processor.
>
> Is your version of uboot sufficiently recent that it passes the correct
> machine ID in r1 ?
>
