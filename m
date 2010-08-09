Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab0HINWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:22:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58446 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab0HINWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:22:53 -0400
MIME-Version: 1.0
In-Reply-To: <20100809103618.GE11340@nokia.com>
References: <1275563341-31078-1-git-send-email-felipe.balbi@nokia.com> 
	<20100809103618.GE11340@nokia.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 9 Aug 2010 07:22:31 -0600
X-Google-Sender-Auth: IG74P6gfBb8tk93BSQB21lkPTQM
Message-ID: <AANLkTinA72_YkcyN=1q04CDG5uW8PiOz5+jg9nTN7PuE@mail.gmail.com>
Subject: Re: [PATCH] spi: omap2_mcspi: make use of dev_vdbg()
To: felipe.balbi@nokia.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "Tereshonkov Roman (Nokia-D/Helsinki)" <roman.tereshonkov@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o79DN2A3020376

On Mon, Aug 9, 2010 at 4:36 AM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
> On Thu, Jun 03, 2010 at 01:09:01PM +0200, Balbi Felipe (Nokia-D/Helsinki)
> wrote:
>>
>> From: Felipe Balbi <felipe.balbi@nokia.com>
>>
>> dev_vdbg() is only compiled when VERBOSE is defined, so
>> there's no need to wrap dev_dbg() on #ifdef VERBOSE .. #endif
>> as we can use dev_vdbg() directly.
>>
>> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
>> ---
>
> ping, any comments to this one ? It's been pending for quite a long time.

It didn't get sent to the spi-devel-general list, so it didn't get
picked up by patchwork and wasn't there for me to pick up when I was
collecting stuff for .36.

g.

>
>> drivers/spi/omap2_mcspi.c |   36 +++++++++---------------------------
>> 1 files changed, 9 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/spi/omap2_mcspi.c b/drivers/spi/omap2_mcspi.c
>> index b3a94ca..d703927 100644
>> --- a/drivers/spi/omap2_mcspi.c
>> +++ b/drivers/spi/omap2_mcspi.c
>> @@ -489,10 +489,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct
>> spi_transfer *xfer)
>>                                        dev_err(&spi->dev, "TXS timed
>> out\n");
>>                                        goto out;
>>                                }
>> -#ifdef VERBOSE
>> -                               dev_dbg(&spi->dev, "write-%d %02x\n",
>> +                               dev_vdbg(&spi->dev, "write-%d %02x\n",
>>                                                word_len, *tx);
>> -#endif
>>                                __raw_writel(*tx++, tx_reg);
>>                        }
>>                        if (rx != NULL) {
>> @@ -506,10 +504,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct
>> spi_transfer *xfer)
>>                                    (l & OMAP2_MCSPI_CHCONF_TURBO)) {
>>                                        omap2_mcspi_set_enable(spi, 0);
>>                                        *rx++ = __raw_readl(rx_reg);
>> -#ifdef VERBOSE
>> -                                       dev_dbg(&spi->dev, "read-%d
>> %02x\n",
>> +                                       dev_vdbg(&spi->dev, "read-%d
>> %02x\n",
>>                                                    word_len, *(rx - 1));
>> -#endif
>>                                        if
>> (mcspi_wait_for_reg_bit(chstat_reg,
>>                                                OMAP2_MCSPI_CHSTAT_RXS) <
>> 0) {
>>                                                dev_err(&spi->dev,
>> @@ -522,10 +518,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct
>> spi_transfer *xfer)
>>                                }
>>
>>                                *rx++ = __raw_readl(rx_reg);
>> -#ifdef VERBOSE
>> -                               dev_dbg(&spi->dev, "read-%d %02x\n",
>> +                               dev_vdbg(&spi->dev, "read-%d %02x\n",
>>                                                word_len, *(rx - 1));
>> -#endif
>>                        }
>>                } while (c);
>>        } else if (word_len <= 16) {
>> @@ -542,10 +536,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct
>> spi_transfer *xfer)
>>                                        dev_err(&spi->dev, "TXS timed
>> out\n");
>>                                        goto out;
>>                                }
>> -#ifdef VERBOSE
>> -                               dev_dbg(&spi->dev, "write-%d %04x\n",
>> +                               dev_vdbg(&spi->dev, "write-%d %04x\n",
>>                                                word_len, *tx);
>> -#endif
>>                                __raw_writel(*tx++, tx_reg);
>>                        }
>>                        if (rx != NULL) {
>> @@ -559,10 +551,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct
>> spi_transfer *xfer)
>>                                    (l & OMAP2_MCSPI_CHCONF_TURBO)) {
>>                                        omap2_mcspi_set_enable(spi, 0);
>>                                        *rx++ = __raw_readl(rx_reg);
>> -#ifdef VERBOSE
>> -                                       dev_dbg(&spi->dev, "read-%d
>> %04x\n",
>> +                                       dev_vdbg(&spi->dev, "read-%d
>> %04x\n",
>>                                                    word_len, *(rx - 1));
>> -#endif
>>                                        if
>> (mcspi_wait_for_reg_bit(chstat_reg,
>>                                                OMAP2_MCSPI_CHSTAT_RXS) <
>> 0) {
>>                                                dev_err(&spi->dev,
>> @@ -575,10 +565,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct
>> spi_transfer *xfer)
>>                                }
>>
>>                                *rx++ = __raw_readl(rx_reg);
>> -#ifdef VERBOSE
>> -                               dev_dbg(&spi->dev, "read-%d %04x\n",
>> +                               dev_vdbg(&spi->dev, "read-%d %04x\n",
>>                                                word_len, *(rx - 1));
>> -#endif
>>                        }
>>                } while (c);
>>        } else if (word_len <= 32) {
>> @@ -595,10 +583,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct
>> spi_transfer *xfer)
>>                                        dev_err(&spi->dev, "TXS timed
>> out\n");
>>                                        goto out;
>>                                }
>> -#ifdef VERBOSE
>> -                               dev_dbg(&spi->dev, "write-%d %08x\n",
>> +                               dev_vdbg(&spi->dev, "write-%d %08x\n",
>>                                                word_len, *tx);
>> -#endif
>>                                __raw_writel(*tx++, tx_reg);
>>                        }
>>                        if (rx != NULL) {
>> @@ -612,10 +598,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct
>> spi_transfer *xfer)
>>                                    (l & OMAP2_MCSPI_CHCONF_TURBO)) {
>>                                        omap2_mcspi_set_enable(spi, 0);
>>                                        *rx++ = __raw_readl(rx_reg);
>> -#ifdef VERBOSE
>> -                                       dev_dbg(&spi->dev, "read-%d
>> %08x\n",
>> +                                       dev_vdbg(&spi->dev, "read-%d
>> %08x\n",
>>                                                    word_len, *(rx - 1));
>> -#endif
>>                                        if
>> (mcspi_wait_for_reg_bit(chstat_reg,
>>                                                OMAP2_MCSPI_CHSTAT_RXS) <
>> 0) {
>>                                                dev_err(&spi->dev,
>> @@ -628,10 +612,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct
>> spi_transfer *xfer)
>>                                }
>>
>>                                *rx++ = __raw_readl(rx_reg);
>> -#ifdef VERBOSE
>> -                               dev_dbg(&spi->dev, "read-%d %08x\n",
>> +                               dev_vdbg(&spi->dev, "read-%d %08x\n",
>>                                                word_len, *(rx - 1));
>> -#endif
>>                        }
>>                } while (c);
>>        }
>> --
>> 1.7.1
>
> --
> balbi
>
> DefectiveByDesign.org
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
