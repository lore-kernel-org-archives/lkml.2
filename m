Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab0GMBOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:14:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40823 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab0GMBOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OTVLZmO6nG4hBroLPIKaC6PsC+rk0ZYNZnvsUHHXW/zyp5heUg6/UmJ2y75RZfHmIs
         hF+7XFACPNu0erHdBKXjAsRT3AZ898UliLOIxIEkx/s1bAqcAS1KJT8btyuTzENmekPq
         Xbvr81QhaQPCsGAnFeyV6tZg4W2MyDubN7Ct8=
MIME-Version: 1.0
In-Reply-To: <81C3A93C17462B4BBD7E272753C10579169F9BD429@EXDCVYMBSTM005.EQ1STM.local>
References: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>
	<AANLkTikHqhx4k-DPGh-Ub13eS02nPuUJniv66sCBF4J1@mail.gmail.com>
	<81C3A93C17462B4BBD7E272753C10579169F9BD429@EXDCVYMBSTM005.EQ1STM.local>
Date: Tue, 13 Jul 2010 10:14:49 +0900
X-Google-Sender-Auth: nmLQ9kTypDDaEo6TJ6OMF0rm0hg
Message-ID: <AANLkTimp1vdnWZ2k1M5j6QcgZ47zHXQqIldgT3TPOE13@mail.gmail.com>
Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
From: Kyungmin Park <kmpark@infradead.org>
To: "P.Hanumath PRASAD" <hanumath.prasad@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 2:40 PM, P.Hanumath PRASAD
<hanumath.prasad@stericsson.com> wrote:
> Hi,
>
> The MMC_DDR_MODE is the flag set in case if the device is set to DDR mode. And this flag is for the host to enable the DDR

Then where can I see your host drivers? I hope to see also.

I wonder if we use the DDR mode, then I first set the DDR mode at both
MMC and host. then no need to send DDR_MODE support for each request.
doesn't it?

Thank you,
Kyungmin Park

>
> Mode for the controller before doing any data transfers in DDR mode.
>
> Thanks & Regards,
> Hanumath
>
> -----Original Message-----
> From: kyungmin78@gmail.com [mailto:kyungmin78@gmail.com] On Behalf Of Kyungmin Park
> Sent: Saturday, July 10, 2010 10:58 AM
> To: P.Hanumath PRASAD
> Cc: linux-kernel@vger.kernel.org; STEricsson_nomadik_linux; Linus WALLEIJ; linux-mmc@vger.kernel.org
> Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
>
> Hi,
>
> Looks good to me except where's use the MMC_DDR_MODE. why do you set
> brq.data.flags |= MMC_DDR_MODE?
>
> Now my SDHCI host don't support eMMC 4.4 but the end of july I can test it.
>
> Thank you,
> Kyungmin Park
>
> On Fri, Jul 9, 2010 at 3:59 PM, Hanumath Prasad
> <hanumath.prasad@stericsson.com> wrote:
>> Add support for Dual Data Rate MMC cards as defined in the 4.4
>> specification.
>>
>> Cc: linux-mmc@vger.kernel.org
>> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
>> Signed-off-by: Hanumath Prasad <hanumath.prasad@stericsson.com>
>> ---
>>  drivers/mmc/card/block.c |   10 +++++++---
>>  drivers/mmc/core/mmc.c   |   37 +++++++++++++++++++++++++++++++++++--
>>  include/linux/mmc/card.h |    5 +++++
>>  include/linux/mmc/core.h |    1 +
>>  include/linux/mmc/host.h |    4 ++++
>>  include/linux/mmc/mmc.h  |   11 +++++++++--
>>  6 files changed, 61 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index cb9fbc8..4eb84eb 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -299,7 +299,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>                        readcmd = MMC_READ_SINGLE_BLOCK;
>>                        writecmd = MMC_WRITE_BLOCK;
>>                }
>> -
>> +               if (mmc_card_ddr_mode(card))
>> +                       brq.data.flags |= MMC_DDR_MODE;
>>                if (rq_data_dir(req) == READ) {
>>                        brq.cmd.opcode = readcmd;
>>                        brq.data.flags |= MMC_DATA_READ;
>> @@ -569,8 +570,11 @@ mmc_blk_set_blksize(struct mmc_blk_data *md, struct mmc_card *card)
>>        struct mmc_command cmd;
>>        int err;
>>
>> -       /* Block-addressed cards ignore MMC_SET_BLOCKLEN. */
>> -       if (mmc_card_blockaddr(card))
>> +       /*
>> +        * Block-addressed and ddr mode supported cards
>> +        * ignore MMC_SET_BLOCKLEN.
>> +        */
>> +       if (mmc_card_blockaddr(card) || mmc_card_ddr_mode(card))
>>                return 0;
>>
>>        mmc_claim_host(card->host);
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
>> index 89f7a25..1d33503 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -227,6 +227,21 @@ static int mmc_read_ext_csd(struct mmc_card *card)
>>        }
>>
>>        switch (ext_csd[EXT_CSD_CARD_TYPE] & EXT_CSD_CARD_TYPE_MASK) {
>> +       case EXT_CSD_CARD_TYPE_DDR_52 | EXT_CSD_CARD_TYPE_52 |
>> +            EXT_CSD_CARD_TYPE_26:
>> +               card->ext_csd.hs_max_dtr = 52000000;
>> +               card->ext_csd.card_type = EXT_CSD_CARD_TYPE_DDR_52;
>> +               break;
>> +       case EXT_CSD_CARD_TYPE_DDR_1_2V | EXT_CSD_CARD_TYPE_52 |
>> +            EXT_CSD_CARD_TYPE_26:
>> +               card->ext_csd.hs_max_dtr = 52000000;
>> +               card->ext_csd.card_type = EXT_CSD_CARD_TYPE_DDR_1_2V;
>> +               break;
>> +       case EXT_CSD_CARD_TYPE_DDR_1_8V | EXT_CSD_CARD_TYPE_52 |
>> +            EXT_CSD_CARD_TYPE_26:
>> +               card->ext_csd.hs_max_dtr = 52000000;
>> +               card->ext_csd.card_type = EXT_CSD_CARD_TYPE_DDR_1_8V;
>> +               break;
>>        case EXT_CSD_CARD_TYPE_52 | EXT_CSD_CARD_TYPE_26:
>>                card->ext_csd.hs_max_dtr = 52000000;
>>                break;
>> @@ -444,6 +459,18 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>>        mmc_set_clock(host, max_dtr);
>>
>>        /*
>> +        * Activate DDR50 mode (if supported).
>> +        */
>> +       if (mmc_card_highspeed(card)) {
>> +               if ((card->ext_csd.card_type & EXT_CSD_CARD_TYPE_DDR_1_8V)
>> +                       && (host->caps & (MMC_CAP_1_8V_DDR)))
>> +                               mmc_card_set_ddr_mode(card);
>> +               else if ((card->ext_csd.card_type & EXT_CSD_CARD_TYPE_DDR_1_2V)
>> +                       && (host->caps & (MMC_CAP_1_2V_DDR)))
>> +                               mmc_card_set_ddr_mode(card);
>> +       }
>> +
>> +       /*
>>         * Activate wide bus (if supported).
>>         */
>>        if ((card->csd.mmca_vsn >= CSD_SPEC_VER_4) &&
>> @@ -451,10 +478,16 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>>                unsigned ext_csd_bit, bus_width;
>>
>>                if (host->caps & MMC_CAP_8_BIT_DATA) {
>> -                       ext_csd_bit = EXT_CSD_BUS_WIDTH_8;
>> +                       if (mmc_card_ddr_mode(card))
>> +                               ext_csd_bit = EXT_CSD_DDR_BUS_WIDTH_8;
>> +                       else
>> +                               ext_csd_bit = EXT_CSD_BUS_WIDTH_8;
>>                        bus_width = MMC_BUS_WIDTH_8;
>>                } else {
>> -                       ext_csd_bit = EXT_CSD_BUS_WIDTH_4;
>> +                       if (mmc_card_ddr_mode(card))
>> +                               ext_csd_bit = EXT_CSD_DDR_BUS_WIDTH_4;
>> +                       else
>> +                               ext_csd_bit = EXT_CSD_BUS_WIDTH_4;
>>                        bus_width = MMC_BUS_WIDTH_4;
>>                }
>>
>> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
>> index d02d2c6..7d0aca8 100644
>> --- a/include/linux/mmc/card.h
>> +++ b/include/linux/mmc/card.h
>> @@ -44,6 +44,7 @@ struct mmc_ext_csd {
>>        unsigned int            sa_timeout;             /* Units: 100ns */
>>        unsigned int            hs_max_dtr;
>>        unsigned int            sectors;
>> +       unsigned int            card_type;
>>  };
>>
>>  struct sd_scr {
>> @@ -97,6 +98,8 @@ struct mmc_card {
>>  #define MMC_STATE_READONLY     (1<<1)          /* card is read-only */
>>  #define MMC_STATE_HIGHSPEED    (1<<2)          /* card is in high speed mode */
>>  #define MMC_STATE_BLOCKADDR    (1<<3)          /* card uses block-addressing */
>> +#define MMC_STATE_HIGHSPEED_DDR (1<<4)          /* card is in high speed */
>> +                                               /* dual data rate mode */
>>        unsigned int            quirks;         /* card quirks */
>>  #define MMC_QUIRK_LENIENT_FN0  (1<<0)          /* allow SDIO FN0 writes outside of the VS CCCR range */
>>  #define MMC_QUIRK_BLKSZ_FOR_BYTE_MODE (1<<1)   /* use func->cur_blksize */
>> @@ -129,11 +132,13 @@ struct mmc_card {
>>  #define mmc_card_present(c)    ((c)->state & MMC_STATE_PRESENT)
>>  #define mmc_card_readonly(c)   ((c)->state & MMC_STATE_READONLY)
>>  #define mmc_card_highspeed(c)  ((c)->state & MMC_STATE_HIGHSPEED)
>> +#define mmc_card_ddr_mode(c)   ((c)->state & MMC_STATE_HIGHSPEED_DDR)
>>  #define mmc_card_blockaddr(c)  ((c)->state & MMC_STATE_BLOCKADDR)
>>
>>  #define mmc_card_set_present(c)        ((c)->state |= MMC_STATE_PRESENT)
>>  #define mmc_card_set_readonly(c) ((c)->state |= MMC_STATE_READONLY)
>>  #define mmc_card_set_highspeed(c) ((c)->state |= MMC_STATE_HIGHSPEED)
>> +#define mmc_card_set_ddr_mode(c) ((c)->state |= MMC_STATE_HIGHSPEED_DDR)
>>  #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
>>
>>  static inline int mmc_card_lenient_fn0(const struct mmc_card *c)
>> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
>> index e4898e9..b31e47a 100644
>> --- a/include/linux/mmc/core.h
>> +++ b/include/linux/mmc/core.h
>> @@ -107,6 +107,7 @@ struct mmc_data {
>>  #define MMC_DATA_WRITE (1 << 8)
>>  #define MMC_DATA_READ  (1 << 9)
>>  #define MMC_DATA_STREAM        (1 << 10)
>> +#define MMC_DDR_MODE    (1 << 11)
>>
>>        unsigned int            bytes_xfered;
>>
>> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
>> index f65913c..c775290 100644
>> --- a/include/linux/mmc/host.h
>> +++ b/include/linux/mmc/host.h
>> @@ -155,6 +155,10 @@ struct mmc_host {
>>  #define MMC_CAP_DISABLE                (1 << 7)        /* Can the host be disabled */
>>  #define MMC_CAP_NONREMOVABLE   (1 << 8)        /* Nonremovable e.g. eMMC */
>>  #define MMC_CAP_WAIT_WHILE_BUSY        (1 << 9)        /* Waits while card is busy */
>> +#define MMC_CAP_1_8V_DDR        (1 << 10)       /* can support */
>> +                                               /* DDR mode at 1.8V */
>> +#define MMC_CAP_1_2V_DDR        (1 << 11)       /* can support */
>> +                                               /* DDR mode at 1.2V */
>>
>>        mmc_pm_flag_t           pm_caps;        /* supported pm features */
>>
>> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
>> index 8a49cbf..fc446de 100644
>> --- a/include/linux/mmc/mmc.h
>> +++ b/include/linux/mmc/mmc.h
>> @@ -268,11 +268,18 @@ struct _mmc_csd {
>>
>>  #define EXT_CSD_CARD_TYPE_26   (1<<0)  /* Card can run at 26MHz */
>>  #define EXT_CSD_CARD_TYPE_52   (1<<1)  /* Card can run at 52MHz */
>> -#define EXT_CSD_CARD_TYPE_MASK 0x3     /* Mask out reserved and DDR bits */
>> +#define EXT_CSD_CARD_TYPE_MASK 0xF     /* Mask out reserved bits */
>> +#define EXT_CSD_CARD_TYPE_DDR_1_8V  (1<<2)   /* Card can run at 52MHz */
>> +                                            /* DDR mode @1.8V or 3V I/O */
>> +#define EXT_CSD_CARD_TYPE_DDR_1_2V  (1<<3)   /* Card can run at 52MHz */
>> +                                            /* DDR mode @1.2V I/O */
>> +#define EXT_CSD_CARD_TYPE_DDR_52       (EXT_CSD_CARD_TYPE_DDR_1_8V  \
>> +                                       | EXT_CSD_CARD_TYPE_DDR_1_2V)
>>
>> -#define EXT_CSD_BUS_WIDTH_1    0       /* Card is in 1 bit mode */
>>  #define EXT_CSD_BUS_WIDTH_4    1       /* Card is in 4 bit mode */
>>  #define EXT_CSD_BUS_WIDTH_8    2       /* Card is in 8 bit mode */
>> +#define EXT_CSD_DDR_BUS_WIDTH_4    5    /* Card is in 4 bit DDR mode */
>> +#define EXT_CSD_DDR_BUS_WIDTH_8    6    /* Card is in 8 bit DDR mode */
>>
>>  /*
>>  * MMC_SWITCH access modes
>> --
>> 1.6.3.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
