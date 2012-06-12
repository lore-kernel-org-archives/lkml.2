Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2FLDMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 23:12:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49485 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2FLDMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 23:12:51 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-52-4fd6b3b1bcfb
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Subhash Jadavani'" <subhashj@codeaurora.org>,
        "'S, Venkatraman'" <svenkatr@ti.com>
References: <000601cd47ab$8ad77c50$a08674f0$%jun@samsung.com>
 <68ac9afd251593ab3df348a469a10adb.squirrel@www.codeaurora.org>
In-reply-to: <68ac9afd251593ab3df348a469a10adb.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v7 1/3] mmc: core: Add packed command feature of eMMC4.5
Date: Tue, 12 Jun 2012 12:12:49 +0900
Message-id: <001a01cd4849$3f287180$bd795480$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1IEIwNdfUrfWRGQKebimG3ZAiK0gAJ5H4Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd2Nm6/5GzSvlra4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW8PTKNqeA8R8WW7/MYGxhfsnUxcnJICJhIfJpxlhXC
	FpO4cG89UJyLQ0hgEaPEvo5dTBDOH0aJXxt3MYJUsQloSfx984YZxBYRkJCYsfcTK0gRs8Am
	Rok33cfBxgoJ1EnMPzMDrIFTwFvi+bdZYCuEBXwkbmx+wgJiswioSlzacxJoAwcHr4CtxLFW
	NZAwr4CgxI/J98BKmAX0JD7+uc0IYctLbF7zlhmkXEJAXeLRX12IE4wkbk2EOIdZQERi34t3
	jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwSD+T2sG4
	ssHiEKMAB6MSD++GDdf8hVgTy4orcw8xSnAwK4nwak0DCvGmJFZWpRblxxeV5qQWH2KU5mBR
	Eudtsr7gLySQnliSmp2aWpBaBJNl4uCUamDc+1ml4VLM/mXL7rRsfTM350TxqqfO60uqKu88
	3yFwq6br1qnzqnNvCQm+9pnYnyjL3RCl/+92fPDE7cqvHVicc5bVlUXf23tH+qJI3uVr7Dld
	Z7LfBiiI6LNNm7b495uSXW9PC526+Zsl+Zm7BEd0qqfXQdH/c6bNdvHbeuu3ikbI39xnHxSv
	K7EUZyQaajEXFScCANQ/CDllAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:
> > +	if ((host->caps2 & MMC_CAP2_PACKED_CMD) &&
> > +			((card->ext_csd.max_packed_writes > 0) ||
> > +			(card->ext_csd.max_packed_reads > 0))) {
> > +		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> > +				EXT_CSD_EXP_EVENTS_CTRL,
> > +				EXT_CSD_PACKED_EVENT_EN,
> > +				card->ext_csd.generic_cmd6_time);
> > +		if (err && err != -EBADMSG)
> > +			goto free_card;
> 
> Subhash suggestion to change to the following is missing:
>      if (  (host->caps2 & MMC_CAP2_PACKED_WR &&
> card->ext_csd.max_packed_writes > 0) ||
>             (host->caps2 & MMC_CAP2_PACKED_RD &&
> card->ext_csd.max_packed_reads > 0)
Thanks to detect.
It'll be applied.

Best regards,
Seungwon Jeon

> 
> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

