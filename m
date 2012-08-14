Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab2HNDvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 23:51:41 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61139 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab2HNDvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 23:51:40 -0400
MIME-Version: 1.0
In-Reply-To: <000e01cd79c2$4c6a8cc0$e53fa640$%cy.chen@samsung.com>
References: <5028CDED.2020307@samsung.com>
	<CAKYAXd--Ta1xL2uMEsArmpsg99x+B21ScJOQAty=RFWWCQ6M2w@mail.gmail.com>
	<000e01cd79c2$4c6a8cc0$e53fa640$%cy.chen@samsung.com>
Date: Tue, 14 Aug 2012 12:51:39 +0900
Message-ID: <CAKYAXd9h5KG09zMm2gO_0keycfBQ-Pq5-Z+tXYrhfuSc0equLQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: card: Skip secure option for MoviNAND.
From: Namjae Jeon <linkinjeon@gmail.com>
To: IAN CHEN <ian.cy.chen@samsung.com>
Cc: cjb@laptop.org, adrian.hunter@intel.com, subhashj@codeaurora.org,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, d.j.shin@samsung.com,
        jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Ian.

Okay, I see. plz add this address in changelog.

I also agree about Linus's suggestion.
So Would you change flag name to be neutral ?
We can distinguish samsung movinand by CID_MANFID_SAMSUNG.
And will reuse quirk flag when same issue occurred from other vendor's
mmc deivce.

Thanks.

2012/8/14, IAN CHEN <ian.cy.chen@samsung.com>:
> Dear Mr. Jeon,
>
> This is workaround for some Samsung eMMC, MoviNAND.
> There are known issue about secure erase & secure trim with these eMMC
> device which I listed by product_name.
> Therefore, for these eMMC devices, we just skip
> mmc_blk_issue_secdiscard_rq() and use mmc_blk_issue_discard_rq() instead.
>
> You could refer this discussion in XDA developers.
>     http://forum.xda-developers.com/showthread.php?t=1644364
>
> https://plus.google.com/111398485184813224730/posts/21pTYfTsCkB#111398485184813224730/posts/21pTYfTsCkB
>
> Regards,
> Ian
>
> -----Original Message-----
> From: Namjae Jeon [mailto:linkinjeon@gmail.com]
> Sent: Monday, August 13, 2012 10:03 PM
> To: IAN CHEN
> Cc: cjb@laptop.org; adrian.hunter@intel.com; subhashj@codeaurora.org;
> linus.walleij@linaro.org; linux-mmc@vger.kernel.org;
> linux-kernel@vger.kernel.org; d.j.shin@samsung.com;
> jongtae22.kim@samsung.com; kyungmin.park@samsung.com;
> jh80.chung@samsung.com
> Subject: Re: [PATCH] mmc: card: Skip secure option for MoviNAND.
>
> Hi. Ian.
>
> known issue ? Would you explain more ?
>
> Thanks.
>
> 2012/8/13 IAN CHEN <ian.cy.chen@samsung.com>:
>> From 5c60eb8be04c7440d6e33b8f72ea2046a3657ac4 Mon Sep 17 00:00:00 2001
>> From: ian.cy.chen <ian.cy.chen@samsung.com>
>> Date: Mon, 13 Aug 2012 10:53:55 +0900
>> Subject: [PATCH] mmc: card: Skip secure option for MoviNAND.
>>
>> For several MoviNAND, there are some known issue with secure option.
>> For these specific MoviNAND device, we skip secure option.
>>
>> Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>
>> ---
>>  drivers/mmc/card/block.c |   24 +++++++++++++++++++++++-
>>  include/linux/mmc/card.h |    1 +
>>  2 files changed, 24 insertions(+), 1 deletions(-)
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
