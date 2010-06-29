Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0F2A5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:57:25 -0400
Received: from koto.vergenet.net ([210.128.90.7]:39871 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab0F2A5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:57:23 -0400
Date: Tue, 29 Jun 2010 09:57:22 +0900
From: Simon Horman <horms@verge.net.au>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: trivial@kernel.org, Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
       Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] trivial: use ARRAY_SIZE
Message-ID: <20100629005722.GL10073@verge.net.au>
References: <1277726121-24732-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277726121-24732-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 03:55:20PM +0400, Kulikov Vasiliy wrote:
> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/staging/otus/hal/hpmain.c |   28 ++++++++++------------------
>  1 files changed, 10 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/staging/otus/hal/hpmain.c b/drivers/staging/otus/hal/hpmain.c
> index 5f412e0..6d2d358 100644
> --- a/drivers/staging/otus/hal/hpmain.c
> +++ b/drivers/staging/otus/hal/hpmain.c
> @@ -430,7 +430,7 @@ void zfInitPhy(zdev_t* dev,  u32_t frequency, u8_t bw40)
>       * Register setting by mode
>       */
>  
> -    entries = sizeof(ar5416Modes) / sizeof(*ar5416Modes);
> +    entries = ARRAY_SIZE(ar5416Modes);
>      zm_msg1_scan(ZM_LV_2, "Modes register setting entries=", entries);
>      for (i=0; i<entries; i++)
>      {
> @@ -496,7 +496,7 @@ void zfInitPhy(zdev_t* dev,  u32_t frequency, u8_t bw40)
>      /*
>       * Common Register setting
>       */
> -    entries = sizeof(ar5416Common) / sizeof(*ar5416Common);
> +    entries = ARRAY_SIZE(ar5416Common);
>      for (i=0; i<entries; i++)
>      {
>          reg_write(ar5416Common[i][0], ar5416Common[i][1]);
> @@ -506,7 +506,7 @@ void zfInitPhy(zdev_t* dev,  u32_t frequency, u8_t bw40)
>      /*
>       * RF Gain setting by freqIndex
>       */
> -    entries = sizeof(ar5416BB_RfGain) / sizeof(*ar5416BB_RfGain);
> +    entries = ARRAY_SIZE(ar5416BB_RfGain);
>      for (i=0; i<entries; i++)
>      {
>          reg_write(ar5416BB_RfGain[i][0], ar5416BB_RfGain[i][freqIndex]);
> @@ -963,7 +963,6 @@ u32_t reverse_bits(u32_t chan_sel)
>  /* Bank 0 1 2 3 5 6 7 */
>  void zfSetRfRegs(zdev_t* dev, u32_t frequency)
>  {
> -    u16_t entries;
>      u16_t freqIndex = 0;
>      u16_t i;
>  
> @@ -984,33 +983,28 @@ void zfSetRfRegs(zdev_t* dev, u32_t frequency)
>      }
>  
>  #if 1
> -    entries = sizeof(otusBank) / sizeof(*otusBank);
> -    for (i=0; i<entries; i++)
> +    for (i=0; i<ARRAY_SIZE(otusBank); i++)

As you are changing this line, I wonder if you might also fix
the white-space at the same time. In particular, a space on
either side of '=' and '<'.

+    for (i = 0; i < ARRAY_SIZE(otusBank); i++)

Ditto multiple times below.

>      {
>          reg_write(otusBank[i][0], otusBank[i][freqIndex]);
>      }
>  #else
>      /* Bank0 */
> -    entries = sizeof(ar5416Bank0) / sizeof(*ar5416Bank0);
> -    for (i=0; i<entries; i++)
> +    for (i=0; i<ARRAY_SIZE(ar5416Bank0); i++)
>      {
>          reg_write(ar5416Bank0[i][0], ar5416Bank0[i][1]);
>      }
>      /* Bank1 */
> -    entries = sizeof(ar5416Bank1) / sizeof(*ar5416Bank1);
> -    for (i=0; i<entries; i++)
> +    for (i=0; i<ARRAY_SIZE(ar5416Bank1); i++)
>      {
>          reg_write(ar5416Bank1[i][0], ar5416Bank1[i][1]);
>      }
>      /* Bank2 */
> -    entries = sizeof(ar5416Bank2) / sizeof(*ar5416Bank2);
> -    for (i=0; i<entries; i++)
> +    for (i=0; i<ARRAY_SIZE(ar5416Bank2); i++)
>      {
>          reg_write(ar5416Bank2[i][0], ar5416Bank2[i][1]);
>      }
>      /* Bank3 */
> -    entries = sizeof(ar5416Bank3) / sizeof(*ar5416Bank3);
> -    for (i=0; i<entries; i++)
> +    for (i=0; i<ARRAY_SIZE(ar5416Bank3); i++)
>      {
>          reg_write(ar5416Bank3[i][0], ar5416Bank3[i][freqIndex]);
>      }
> @@ -1018,14 +1012,12 @@ void zfSetRfRegs(zdev_t* dev, u32_t frequency)
>      reg_write (0x98b0,  0x00000013);
>      reg_write (0x98e4,  0x00000002);
>      /* Bank6 */
> -    entries = sizeof(ar5416Bank6) / sizeof(*ar5416Bank6);
> -    for (i=0; i<entries; i++)
> +    for (i=0; i<ARRAY_SIZE(ar5416Bank6); i++)
>      {
>          reg_write(ar5416Bank6[i][0], ar5416Bank6[i][freqIndex]);
>      }
>      /* Bank7 */
> -    entries = sizeof(ar5416Bank7) / sizeof(*ar5416Bank7);
> -    for (i=0; i<entries; i++)
> +    for (i=0; i<ARRAY_SIZE(ar5416Bank7); i++)
>      {
>          reg_write(ar5416Bank7[i][0], ar5416Bank7[i][1]);
>      }
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
