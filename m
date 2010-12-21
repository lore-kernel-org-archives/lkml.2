Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab0LUBD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:03:58 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:34599 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881Ab0LUBD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:03:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=IueJ2Phq9qMsdvqRdqfIwUofhFrznPBxf9UuHqg021D2VUO8A3lVgb+pq+8bCQ1fgo
         6I7SyNCTrzsGIIX1/02ABaWnVTm7M3JdVl/UcKtPZBkdMLN9OA/6uGKejMi/IQzbAJWz
         1TzlhCzRw2tYoBm2k2mMgPO20zWY2MpwkiDno=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=7E7rAc=46p5d6YSpLeut5yehmBtLa4TVofefp@mail.gmail.com>
References: <1292866298-8585-1-git-send-email-per.forlin@stericsson.com>
	<AANLkTi=7E7rAc=46p5d6YSpLeut5yehmBtLa4TVofefp@mail.gmail.com>
Date: Mon, 20 Dec 2010 17:03:56 -0800
X-Google-Sender-Auth: ynsdcTU9SeW-BCAM6KEYKWFRgzk
Message-ID: <AANLkTin=U6j4XTmCq4H4sKivD+jecxor3Q-7mYFDfD=N@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: dma40: Add support to split up large elements
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Per Forlin <per.forlin@stericsson.com>, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 2:08 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> 2010/12/20 Per Forlin <per.forlin@stericsson.com>:
>
>> The maximum transfer size of the stedma40 is (64k-1) x data-width.
>> If the transfer size of one element exceeds this limit
>> the job is split up and sent as linked transfer.
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
>
> I think this could actually go into 2.6.37 series: I consider it
> a bug fix since the transfer size limitation breaks the
> contract of the memcpy() API.
>

If that is the case then the temporary fix for 2.6.37 is along the
lines of fixing up the clients to not submit such large requests.  You
mention the "memcpy api contract" can this be triggered outside of
dmatest?  The other memcpy clients NET_DMA and ASYNC_TX_DMA will never
submit an operation larger than PAGE_SIZE.

"4 files changed, 351 insertions(+), 130 deletions(-)" is difficult to
defend at this stage of the game, if a smaller "don't do that" patch
will suffice for 2.6.37.

--
Dan
