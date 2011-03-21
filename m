Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab1CUH5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 03:57:24 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:14404 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1CUH5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 03:57:21 -0400
X-IronPort-AV: E=Sophos;i="4.63,218,1299474000"; 
   d="scan'208";a="31014658"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Richard Genoud <richard.genoud@gmail.com>
CC: "stable@kernel.org" <stable@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-driver-devel@blackfin.uclinux.org" 
	<device-driver-devel@blackfin.uclinux.org>
Date: Mon, 21 Mar 2011 07:57:14 +0000
Subject: RE: [PATCH] ad525x_dpot: [BUG] eeprom command send instead of
 dec/inc all commands
Thread-Topic: [PATCH] ad525x_dpot: [BUG] eeprom command send instead of
 dec/inc all commands
Thread-Index: Acvgtqy4C/j8pMPpTN6PtkB2VuX6WAG5t+Cg
Message-ID: <544AC56F16B56944AEC3BD4E3D59177137543155EF@LIMKCMBX1.ad.analog.com>
References: <1299935301-3849-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1299935301-3849-1-git-send-email-richard.genoud@gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Genoud wrote on 2011-03-12:
> When a DEC_ALL or INC_ALL command is issued, an eeprom command is send.
> This is because DPOT_DEC_ALL (DPOT_ADDR_CMD | 0x30) and DPOT_INC_ALL
> (DPOT_ADDR_CMD | 0x58) defines overlap with DPOT_ADDR_EEPROM (0x20).
>
> So, DPOT_ADDR_CMD bit should be tested before DPOT_ADDR_EEPROM bit.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>  drivers/misc/ad525x_dpot.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
> index 7cb9110..b6c5391 100644
> --- a/drivers/misc/ad525x_dpot.c
> +++ b/drivers/misc/ad525x_dpot.c
> @@ -289,8 +289,6 @@ static s32 dpot_write_spi(struct dpot_data *dpot,
> u8 reg, u16 value)
>                       }
>                       val = DPOT_SPI_RDAC | (reg & DPOT_RDAC_MASK);
>               }
> -     } else if (reg & DPOT_ADDR_EEPROM) {
> -             val = DPOT_SPI_EEPROM | (reg & DPOT_RDAC_MASK);
>       } else if (reg & DPOT_ADDR_CMD) {
>               switch (reg) {
>               case DPOT_DEC_ALL_6DB:
> @@ -306,6 +304,8 @@ static s32 dpot_write_spi(struct dpot_data *dpot,
> u8 reg, u16 value)
>                       val = DPOT_SPI_INC_ALL;
>                       break;
>               }
> +     } else if (reg & DPOT_ADDR_EEPROM) {
> +             val = DPOT_SPI_EEPROM | (reg & DPOT_RDAC_MASK);
>       } else if (reg & DPOT_ADDR_OTP) {
>               if (dpot->uid == DPOT_UID(AD5291_ID) ||
>                       dpot->uid == DPOT_UID(AD5292_ID)) {

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368; Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif

