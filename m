Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0EQM6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:58:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36975 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab0EQM6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cGmGp6e1sOkTYqr2z0c8PfTN87n3nGBb1+ohPpaXfe29ibLYoGjK9+OEU2h0IxBecI
         JDoFHqhf3aw8piF5Y7Ac0Co3O7NeO6P449hjYdqdlSTaKJlH4OjR8hHc3hNX/WR900lR
         FyLZsJqwo6SE/liP4clIhKrrByKAMb3seMt4Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTinAmHkVBii9nTZ5tNYU21whHy8awP55nGEc-8Tp@mail.gmail.com>
References: <1273641798-26579-1-git-send-email-jassi.brar@samsung.com>
	 <AANLkTinAmHkVBii9nTZ5tNYU21whHy8awP55nGEc-8Tp@mail.gmail.com>
Date: Mon, 17 May 2010 21:58:35 +0900
Message-ID: <AANLkTikeRmB7DdO1Nrvzz-jVV8CmISA5C_9f2kgpeLEO@mail.gmail.com>
Subject: Re: [PATCH] DMA: PL330: Add dma api driver
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jassi Brar <jassi.brar@samsung.com>, jy0922.shim@samsung.com,
       linus.ml.walleij@gmail.com, maciej.sosnowski@intel.com,
       linux-kernel@vger.kernel.org, ben-linux@fluff.org,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 6:55 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, May 11, 2010 at 10:23 PM, Jassi Brar <jassi.brar@samsung.com> wrote:

>> +static void dma_pl330_rqcb(void *token, enum pl330_op_err err)
>> +{
>> +       struct dma_pl330_desc *desc = token;
>> +       struct dma_pl330_chan *pch = desc->pchan;
>> +       unsigned long flags;
>> +
>> +       /* If desc aborted */
>> +       if (!pch)
>> +               return;
>> +
>> +       spin_lock_irqsave(&pch->lock, flags);
>> +
>> +       desc->status = DONE;
>> +
>> +       spin_unlock_irqrestore(&pch->lock, flags);
>
> I don't think you need the lock here.  Assigning an integer is atomic,
> and you reschedule the tasklet.
yes right

> Since this patch depends on the generic bits in Russell's tree I need
> to wait until after the ARM tree is pulled to take it through the dma
> tree.  So, for now...
>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
Thanks
