Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab1FAOyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:54:33 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49630 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab1FAOyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:54:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=e0zSuci4u8d8aXFiPjKzcWCk1x7waLQhMPgZdhpsNWv0+4w+L0QsJSoOnY6iPnUaH2
         QJt0LIcKh4lRfVftzfmViCm9NZuVkuhqIREvPPqn2D/CHm2Eb/zeKijttrwPCtLBidjh
         Y5M6KD8TY90NdcXxJwpfK9j/VI5tKbcVzQHXk=
MIME-Version: 1.0
In-Reply-To: <1306935129.1097.3.camel@hcegtvedt.norway.atmel.com>
References: <1306676962-22308-1-git-send-email-dbaryshkov@gmail.com>
	<1306935129.1097.3.camel@hcegtvedt.norway.atmel.com>
Date: Wed, 1 Jun 2011 18:54:30 +0400
Message-ID: <BANLkTi=s4kGg5NKrzNs1nu8S00Ue_Zv8vQ@mail.gmail.com>
Subject: Re: [PATCH] ATMEL, AVR32: inline nand partition table access
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/11, Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:
> On Sun, 2011-05-29 at 17:49 +0400, Dmitry Eremin-Solenikov wrote:
>> Currently atmel_nand driver used by AT91 and AVR32 calls a special
>> callback
>> which return nand partition table and number of partitions. However in all
>> boards this callback returns just static data. So drop this callback and
>> make atmel_nand use partition table provided statically via platform_data.
>>
>> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>
> Thanks for this update, always nice seeing code being optimized. I
> really can't recall why it was made like this in the first place...
>
> For the AVR32 related parts:
>
> Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
>
> <snipp diff>
>
> Will this go through the linux-mtd tree (since it spans two archs) or
> should it go through an arch tree?

On one hand, I'd prefer for this to go through the linux-mtd, if noone objects,
as I'd also like to submit several (a pile) patches cleaning up mtd
partitioning, which would depend on this.

OTOH, I think there will be a cleanup of AT91 platform, which would bring
lot's of conflicts with this patch, if it goes through linux-mtd.

-- 
With best wishes
Dmitry
