Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2HNCLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:11:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40591 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab2HNCLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:11:43 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-d4-5029b3d3741b
From: IAN CHEN <ian.cy.chen@samsung.com>
To: "'Namjae Jeon'" <linkinjeon@gmail.com>
Cc: cjb@laptop.org, adrian.hunter@intel.com, subhashj@codeaurora.org,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, d.j.shin@samsung.com,
        jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com
References: <5028CDED.2020307@samsung.com>
 <CAKYAXd--Ta1xL2uMEsArmpsg99x+B21ScJOQAty=RFWWCQ6M2w@mail.gmail.com>
In-reply-to: <CAKYAXd--Ta1xL2uMEsArmpsg99x+B21ScJOQAty=RFWWCQ6M2w@mail.gmail.com>
Subject: RE: [PATCH] mmc: card: Skip secure option for MoviNAND.
Date: Tue, 14 Aug 2012 11:12:47 +0900
Message-id: <000e01cd79c2$4c6a8cc0$e53fa640$%cy.chen@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac15U/X/RN2xdH42R6eCpMthNpQDNQAbkpUg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd3LmzUDDB72C1lc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDK2Pf/PXnCQt2LapGPsDYwbubsYOTkkBEwkJl3/wwph
	i0lcuLeerYuRi0NIYBGjxO91s1ggnL+MEtcfXWcDqWIT0JD4fvAJI4gtAmQ/2L6VHaSIWaCR
	SWJzx3xmkISQQKHEij+bwWxOgWCJI3M+gTULCzhIfGyZCraORUBV4vWOn0wgNq+Ao8TtT5/Z
	IGxBiR+T77GA2MwC6hKT5i1ihrC1JZ68uwDUywF0qrrEo7+6EDcYSdxdco0NokRcYtKDh+wT
	GIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcFA/k97BuKrB
	4hCjAAejEg9vYaJmgBBrYllxZe4hRgkOZiUR3vs9QCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
	Jt5f/YUE0hNLUrNTUwtSi2CyTBycUg2MtjMuJ9z6v2eS8q8ljE2hF6vtdZjT20KmK/68zvz+
	D+uplfvYe5ZvSg2YxJfrWZC6r+y+xYqlk5T/f9/mLF4wZ+WrqGu7Fxw+xbNKom/G4xkLJ3FM
	Sk/8k8r9e95/tg1pF9oNz8x8+OeJd/dU12wBwYSLXwKnC11J5q3oX56zdBVrSqbZ7bUPYpVY
	ijMSDbWYi4oTAWPnhqxmAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Jeon,

This is workaround for some Samsung eMMC, MoviNAND.
There are known issue about secure erase & secure trim with these eMMC device which I listed by product_name.
Therefore, for these eMMC devices, we just skip mmc_blk_issue_secdiscard_rq() and use mmc_blk_issue_discard_rq() instead.

You could refer this discussion in XDA developers.
    http://forum.xda-developers.com/showthread.php?t=1644364
    https://plus.google.com/111398485184813224730/posts/21pTYfTsCkB#111398485184813224730/posts/21pTYfTsCkB

Regards,
Ian

-----Original Message-----
From: Namjae Jeon [mailto:linkinjeon@gmail.com] 
Sent: Monday, August 13, 2012 10:03 PM
To: IAN CHEN
Cc: cjb@laptop.org; adrian.hunter@intel.com; subhashj@codeaurora.org; linus.walleij@linaro.org; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; d.j.shin@samsung.com; jongtae22.kim@samsung.com; kyungmin.park@samsung.com; jh80.chung@samsung.com
Subject: Re: [PATCH] mmc: card: Skip secure option for MoviNAND.

Hi. Ian.

known issue ? Would you explain more ?

Thanks.

2012/8/13 IAN CHEN <ian.cy.chen@samsung.com>:
> From 5c60eb8be04c7440d6e33b8f72ea2046a3657ac4 Mon Sep 17 00:00:00 2001
> From: ian.cy.chen <ian.cy.chen@samsung.com>
> Date: Mon, 13 Aug 2012 10:53:55 +0900
> Subject: [PATCH] mmc: card: Skip secure option for MoviNAND.
>
> For several MoviNAND, there are some known issue with secure option.
> For these specific MoviNAND device, we skip secure option.
>
> Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>
> ---
>  drivers/mmc/card/block.c |   24 +++++++++++++++++++++++-
>  include/linux/mmc/card.h |    1 +
>  2 files changed, 24 insertions(+), 1 deletions(-)
>

