Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742Ab1JaJpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:45:17 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:53041 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab1JaJpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:45:16 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2dK9371K1432N98dKzz1202hzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
Message-ID: <4EAE6DDF.6010608@analog.com>
Date: Mon, 31 Oct 2011 10:43:59 +0100
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [PATCH] mfd: adp5520: Ensure setting bits if new value is different
 from the old value
References: <1320030006.2690.8.camel@phoenix>
In-Reply-To: <1320030006.2690.8.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 04:00 AM, Axel Lin wrote:
> Current code checks if all the bit_mask bits are all zero is wrong.
> We need to write new value if the bit mask fields of new value is
> not equal to old value.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>

Right - the da903x suffers the same problem.

> ---
>   drivers/mfd/adp5520.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
> index f1d8848..8d816cc 100644
> --- a/drivers/mfd/adp5520.c
> +++ b/drivers/mfd/adp5520.c
> @@ -109,7 +109,7 @@ int adp5520_set_bits(struct device *dev, int reg, uint8_t bit_mask)
>
>   	ret = __adp5520_read(chip->client, reg,&reg_val);
>
> -	if (!ret&&  ((reg_val&  bit_mask) == 0)) {
> +	if (!ret&&  ((reg_val&  bit_mask) != bit_mask)) {
>   		reg_val |= bit_mask;
>   		ret = __adp5520_write(chip->client, reg, reg_val);
>   	}


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


