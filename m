Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab2E2Mpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:45:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17978 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2E2Mpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:45:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6725"; a="193202893"
From: "Subhash Jadavani" <subhashj@codeaurora.org>
To: <merez@codeaurora.org>, "'Seungwon Jeon'" <tgih.jun@samsung.com>
Cc: <linux-mmc@vger.kernel.org>, "'Chris Ball'" <cjb@laptop.org>,
        <linux-kernel@vger.kernel.org>
References: <009d01cd3411$0febc350$2fc349f0$%jun@samsung.com> <d98d78ec2312cbc5edb1b2c337ab788d.squirrel@www.codeaurora.org>
In-Reply-To: <d98d78ec2312cbc5edb1b2c337ab788d.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v6 1/3] mmc: core: Add packed command feature of eMMC4.5
Date: Tue, 29 May 2012 18:15:29 +0530
Message-ID: <000001cd3d98$f015db60$d0419220$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFcCsV+SUy7m9HOCPoh/CTR9DueOALLFy6Yl6zDHjA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> owner@vger.kernel.org] On Behalf Of merez@codeaurora.org
> Sent: Tuesday, May 29, 2012 5:08 PM
> To: Seungwon Jeon
> Cc: linux-mmc@vger.kernel.org; 'Chris Ball'; merez@codeaurora.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v6 1/3] mmc: core: Add packed command feature of
> eMMC4.5
> 
> > @@ -1244,6 +1249,25 @@ static int mmc_init_card(struct mmc_host *host,
> > u32 ocr,
> >  		}
> >  	}
> >
> > +	if ((host->caps2 & MMC_CAP2_PACKED_CMD) &&
> > +			(card->ext_csd.max_packed_writes > 0) &&
> > +			(card->ext_csd.max_packed_reads > 0)) {
> > +		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> > +				EXT_CSD_EXP_EVENTS_CTRL,
> > +				EXT_CSD_PACKED_EVENT_EN,
> > +				card->ext_csd.generic_cmd6_time);
> > +		if (err && err != -EBADMSG)
> > +			goto free_card;
> > +		if (err) {
> > +			pr_warning("%s: Enabling packed event failed\n",
> > +					mmc_hostname(card->host));
> > +			card->ext_csd.packed_event_en = 0;
> > +			err = 0;
> > +		} else {
> > +			card->ext_csd.packed_event_en = 1;
> > +		}
> > +	}
> > +
> The above shoud not be performed in case of resume. Therefore it needs to
be
> done only if (!oldcard)

Maya,
What if eMMC power (VCC and VCCQ) was removed during suspend? Then in that
case during resume, we have to send this mmc_switch() command again. So this
operation should not be under "if (!oldcard)" check.

Regards,
Subhash


> 
> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

