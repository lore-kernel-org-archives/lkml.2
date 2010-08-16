Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0HPMOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:14:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41527 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0HPMOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:14:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VIq1ezB0gBW3S+6lNh4ktYphKc3RYqXH6myg7ZC5hoBuFVUGv7QIGZPM0UfMk9OV/a
         sIev7lglFPJuY3c77SkYGWcxzc0JaYk1e6VAebckLZRfQu2sMngcqEkpu+SlAvwGFvfh
         JwJQIxkxyIMLllzcOmHgTxyrkDCXX+C78hcUo=
MIME-Version: 1.0
In-Reply-To: <1281954738.21549.65.camel@localhost>
References: <1281946149.10299.1.camel@mola> <1281954738.21549.65.camel@localhost>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 16 Aug 2010 20:14:27 +0800
Message-ID: <AANLkTingMJHJPwh5BeAKT___R2kE4t_XZoobuFrEsaHu@mail.gmail.com>
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix ns2cycle equation
To: David Woodhouse <dwmw2@infradead.org>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Reimer <mreimer@vpop.net>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 6:32 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2010-08-16 at 16:09 +0800, Axel Lin wrote:
>> Test on a PXA310 platform with Samsung K9F2G08X0B NAND flash,
>> with tCH=5 and clk is 156MHz, ns2cycle(5, 156000000) returns -1.
>>
>> ns2cycle returns negtive value will break NDTR0_tXX macros.
>>
>> After checking the commit log, I found the problem is introduced by
>> commit 5b0d4d7c8a67c5ba3d35e6ceb0c5530cc6846db7
>> "[MTD] [NAND] pxa3xx: convert from ns to clock ticks more accurately"
>>
>> To get num of clock cycles, we use below equation:
>> num of clock cycles = time (ns) / one clock cycle (ns) + 1
>> We need to add 1 cycle here because integer division will truncate the result.
>> It is possible the developers set the Min values in SPEC for timing settings.
>> Thus the truncate may cause problem, and it is safe to add an extra cycle here.
>>
>> The various fields in NDTR{01} are in units of clock ticks minus one,
>> thus we should subtract 1 cycle then.
>>
>> Thus the correct equation should be:
>> num of clock cycles = time (ns) / one clock cycle (ns) + 1 - 1
>>                     = time (ns) / one clock cycle (ns)
>
> Looks sane to me; thanks. Wants to go to stable@ too, yes?
>
> Can I have an Acked-By: from Matt and/or Eric?
>

Acked-by: Eric Miao <eric.y.miao@gmail.com>
