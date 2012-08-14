Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2HNCIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:08:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32514 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab2HNCIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:08:50 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-2e-5029b3312d4a
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
Date: Tue, 14 Aug 2012 11:10:04 +0900
Message-id: <000101cd79c1$ebf01040$c3d030c0$%cy.chen@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac15U/X/RN2xdH42R6eCpMthNpQDNQAbd72w
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQV3DzZoBBvcuiltc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ2XWpiLTjCW/Fx/lL2BsYt3F2MnBwSAiYSHx9eYYWw
	xSQu3FvP1sXIxSEkMJ1R4unmfmYI5y+jxI3v/WwgVWwCGhLfDz5hBLFFgOwH27eygxQxCzQy
	SWzumM8MkhASKJRY8WczmM0pECxxZM4nsGZhAQeJjy1TgdZxcLAIqErs+20DEuYVcJTY9ewZ
	G4QtKPFj8j0WEJtZQF1i0rxFzBC2tsSTdxfAWiWA4o/+6kKcYCRx7NcBqHJxiUkPHrJPYBSa
	hWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwSH9TGoH48oGi0OM
	AhyMSjy8CmmaAUKsiWXFlbmHGCU4mJVEeO/3AIV4UxIrq1KL8uOLSnNSiw8xSnOwKInzGnt/
	9RcSSE8sSc1OTS1ILYLJMnFwSjUwds74Xid8zzxD6dWFBd1qaitzI34zrBOw0RbNe6dcUbPo
	4maODd5sNuHdGtYzLMVYd0r/5v0ku9HxhPq/Bq6D5a/KTXw92GSkv7/cuFMpZdVmi7mn7SQE
	dqc1neZJ/fR785Vl/sbHmWct2pO6/cnm0AWX03Uy+c56h83WnHK29rS78YU5WclOSizFGYmG
	WsxFxYkAoqhhUWUCAAA=
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

