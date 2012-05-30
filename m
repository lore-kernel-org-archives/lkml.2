Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2E3AUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 20:20:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39355 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2E3AUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 20:20:36 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-e2-4fc567d2a159
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <009d01cd3411$0febc350$2fc349f0$%jun@samsung.com>
 <d98d78ec2312cbc5edb1b2c337ab788d.squirrel@www.codeaurora.org>
In-reply-to: <d98d78ec2312cbc5edb1b2c337ab788d.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v6 1/3] mmc: core: Add packed command feature of eMMC4.5
Date: Wed, 30 May 2012 09:20:34 +0900
Message-id: <001d01cd3dfa$07f83dc0$17e8b940$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac09j4vgcnVcL5NRTyiy6BQNVHElOAAaAQJA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd3L6Uf9DToXMllc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLauk+xFGziqlgy8TV7A2MTRxcjB4eEgInE9x7BLkZO
	IFNM4sK99WxdjFwcQgKLGCW6GqazQjh/GCWWzTrKClLFJqAl8ffNG2YQW0RAQmLG3k9gcWaB
	GIn5rQdYQGwhgTqJru1zmEBsTgFvicUtq8HqhQV8JGZ+XckOYrMIqErcPv0SzOYVsJV4uuk1
	I4QtKPFj8j0WkOOYBfQk7l/UghgvL7F5zVtmiJvVJR791YW4wEji35ZFUBeISOx78Y5xAqPQ
	LCSDZiEMmoVk0CwkHQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfzM6kdjCsbLA4x
	CnAwKvHwJige9RdiTSwrrsw9xCjBwawkwutvAhTiTUmsrEotyo8vKs1JLT7EKM3BoiTOa7d4
	h7+QQHpiSWp2ampBahFMlomDU6qBMZxjytnvEq/1+ht1o0+vMt99jTfY1i/+0OO+76uPih7o
	nZa40N7EancI/ye20LmzbTlrfqvE911dcPT6nQWvtN8+ety4UJKX2ZsvuvungotaQKm8cEDd
	ipqo/vmOlxds+7JXs3dy0Cebe/q8kVu6cjUEdt9M/FchJqBhnFSQzsslUrb5U+MnJZbijERD
	Leai4kQA3jJVWmICAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:
> > @@ -1244,6 +1249,25 @@ static int mmc_init_card(struct mmc_host *host, u32
> > ocr,
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
> be done only if (!oldcard)
Could you explain the reason for this?

Thanks,
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

