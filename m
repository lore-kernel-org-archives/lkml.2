Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2HNEKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 00:10:43 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34100 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2HNEKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 00:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2WgBa29dT2Vm5ULyMYSsQ=d+8ViXi=q_LQqWudJK3OwXA@mail.gmail.com>
References: <5029CE38.4000407@samsung.com>
	<CAH9JG2WgBa29dT2Vm5ULyMYSsQ=d+8ViXi=q_LQqWudJK3OwXA@mail.gmail.com>
Date: Tue, 14 Aug 2012 13:10:40 +0900
X-Google-Sender-Auth: ojd43k93mgy2GB18b0sqw1H2E3E
Message-ID: <CAH9JG2Vb-0WM48-zGsLA3q-55vogbNWtTz8k+BjeHL1XSaXjVw@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: card: Skip secure option for MoviNAND.
From: Kyungmin Park <kyungmin.park@samsung.com>
To: IAN CHEN <ian.cy.chen@samsung.com>
Cc: cjb@laptop.org, linkinjeon@gmail.com, adrian.hunter@intel.com,
        subhashj@codeaurora.org, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        d.j.shin@samsung.com, jongtae22.kim@samsung.com,
        jh80.chung@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and also you should update "MMC_QUIRK_MOVINAND_SECURE" also.

On 8/14/12, Kyungmin Park <kyungmin.park@samsung.com> wrote:
> Hi Ian,
>
> "MMC_QUIRK_SKIP_SECURE"? It seems it support secure discard but want
> to skip. but it's wrong. it's broken feature at listed MoviNAND.
> As linus suggested, SECURE_BROKEN is better.
>
> Thank you,
> Kyungmin Park
>
> On 8/14/12, IAN CHEN <ian.cy.chen@samsung.com> wrote:
>> For several MoviNAND, there are some known issue with secure option.
>> For these specific MoviNAND device, we skip secure option.
>>
>> Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>
>> ---
>>  drivers/mmc/card/block.c |   24 +++++++++++++++++++++++-
>>  include/linux/mmc/card.h |    1 +
>>  2 files changed, 24 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index f1c84de..a01cc14 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -1411,7 +1411,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq,
>> struct request *req)
>>  		/* complete ongoing async transfer before issuing discard */
>>  		if (card->host->areq)
>>  			mmc_blk_issue_rw_rq(mq, NULL);
>> -		if (req->cmd_flags & REQ_SECURE)
>> +		if (req->cmd_flags & REQ_SECURE &&
>> +			!(card->quirks & MMC_QUIRK_SKIP_SECURE))
>>  			ret = mmc_blk_issue_secdiscard_rq(mq, req);
>>  		else
>>  			ret = mmc_blk_issue_discard_rq(mq, req);
>> @@ -1716,6 +1717,7 @@ force_ro_fail:
>>  #define CID_MANFID_SANDISK	0x2
>>  #define CID_MANFID_TOSHIBA	0x11
>>  #define CID_MANFID_MICRON	0x13
>> +#define CID_MANFID_SAMSUNG	0x15
>>
>>  static const struct mmc_fixup blk_fixups[] =
>>  {
>> @@ -1752,6 +1754,26 @@ static const struct mmc_fixup blk_fixups[] =
>>  	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_MICRON, 0x200, add_quirk_mmc,
>>  		  MMC_QUIRK_LONG_READ_TIME),
>>
>> +	/*
>> +	 * Some issue about secure erase/secure trim for Samsung MoviNAND
>> +	 */
>> +	MMC_FIXUP("M8G2FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
>> +		  MMC_QUIRK_MOVINAND_SECURE),
>> +	MMC_FIXUP("MAG4FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
>> +		  MMC_QUIRK_MOVINAND_SECURE),
>> +	MMC_FIXUP("MBG8FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
>> +		  MMC_QUIRK_MOVINAND_SECURE),
>> +	MMC_FIXUP("MCGAFA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
>> +		  MMC_QUIRK_MOVINAND_SECURE),
>> +	MMC_FIXUP("VAL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
>> +		  MMC_QUIRK_MOVINAND_SECURE),
>> +	MMC_FIXUP("VYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
>> +		  MMC_QUIRK_MOVINAND_SECURE),
>> +	MMC_FIXUP("KYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
>> +		  MMC_QUIRK_MOVINAND_SECURE),
>> +	MMC_FIXUP("VZL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
>> +		  MMC_QUIRK_MOVINAND_SECURE),
>> +
>>  	END_FIXUP
>>  };
>>
>> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
>> index 111aca5..b639a92 100644
>> --- a/include/linux/mmc/card.h
>> +++ b/include/linux/mmc/card.h
>> @@ -239,6 +239,7 @@ struct mmc_card {
>>  #define MMC_QUIRK_BLK_NO_CMD23	(1<<7)		/* Avoid CMD23 for regular
>> multiblock */
>>  #define MMC_QUIRK_BROKEN_BYTE_MODE_512 (1<<8)	/* Avoid sending 512
>> bytes in */
>>  #define MMC_QUIRK_LONG_READ_TIME (1<<9)		/* Data read time > CSD says */
>> +#define MMC_QUIRK_SKIP_SECURE (1<<10)		/* Skip secure for erase/trim */
>>  						/* byte mode */
>>  	unsigned int    poweroff_notify_state;	/* eMMC4.5 notify feature */
>>  #define MMC_NO_POWER_NOTIFICATION	0
>> --
>> 1.7.0.4
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
