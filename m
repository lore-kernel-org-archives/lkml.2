Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab0JLLJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 07:09:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37077 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab0JLLJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 07:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lw+pQzmwAbFxjBM4saJVJ9f5ei48tds7n8E6rbX4eAZ39drTyk0+O/yP08Jr32mymA
         6KKihpgiwxdt4nCtdanmpddMIGJELblVtg5tF14UrcNycAA0i4mwqfm3vwXE7IcCqIs0
         vnaG5P3NwH7ydESL/L68bHFmZoeEAVBG1UUkA=
MIME-Version: 1.0
In-Reply-To: <496565EC904933469F292DDA3F1663E602F47B2BF1@dlee06.ent.ti.com>
References: <1286226137-1233-1-git-send-email-x0095840@ti.com>
	<1286226137-1233-2-git-send-email-x0095840@ti.com>
	<1286226137-1233-3-git-send-email-x0095840@ti.com>
	<AANLkTimF5HqA0pbp7NXOXxOcuMMJWp9yuJPsw8-iPKjh@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F47B2BF1@dlee06.ent.ti.com>
Date: Tue, 12 Oct 2010 14:09:10 +0300
Message-ID: <AANLkTinVzO_B0L09bOG0aWTsQjaXgLeggB+YUgEhL2Sa@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] iovmm: add superpages support to fixed da address
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "david.cohen@nokia.com" <david.cohen@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 6:33 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
>> > @@ -420,7 +431,8 @@ static void sgtable_fill_kmalloc(struct
>> sg_table
>> > *sgt, u32 pa, size_t len)
>> >        for_each_sg(sgt->sgl, sg, sgt->nents, i) {
>> >                size_t bytes;
>> >
>> > -               bytes = iopgsz_max(len);
>> > +               bytes = max_alignment(da | pa);
>> > +               bytes = min(bytes, (size_t)iopgsz_max(len));
>>
>> Why the size_t casting?
>
> To void this warning:
> arch/arm/plat-omap/iovmm.c:440: warning: comparison of distinct pointer types lacks a cast

But how is that possible? iopgsz_max is returning constants, like
SZ_1M, so they should not need casts, if anything, the cast should be
done in iopgsz_max itself.

-- 
Felipe Contreras
