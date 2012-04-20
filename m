Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab2DTP6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:58:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab2DTP6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:58:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH RESEND v3] iio: Add device tree support to LPC32xx ADC
Date: Fri, 20 Apr 2012 15:58:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "Lars-Peter Clausen" <lars@metafoo.de>, jic23@cam.ac.uk,
        gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kevin Wells <kevin.wells@nxp.com>,
        Srinivas Bakki <srinivas.bakki@nxp.com>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1334932713-19231-1-git-send-email-stigge@antcom.de> <4F917AE3.7050808@metafoo.de> <4F91824A.10207@antcom.de>
In-Reply-To: <4F91824A.10207@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204201558.48987.arnd@arndb.de>
X-Provags-ID: V02:K0:5MsCi7otyN9fVjAkaTj6+qEEmHeEk/birJGQ2RHzBnW
 od8mZKD8l+NMlXQqZDFYlm+2QVvm+0qe82y+Ex5QpgPH0ArWWH
 bDlALhuGZ+i/2f+ZHditutGUQqZHN6stpLkwH7vsB2uU/tBTaR
 iinLJdU80NbKbiXQOcYsTd4sPVXkkP5rzJZGdAyW72ogNmguO8
 9QeLGiSZxGzlWbSBO9bW+OS69Jsop7e9HbmLkXXqlhW4YNnRKJ
 kMYtCSr+aCTJKco9qM66AhtKNyipPRVD0T2MTy9tgfh0vKarQB
 DjCWOjNAOhmD4vO9pA6dhT7eUVqECcNFCGzQlS3EIV/NVCObvz
 OsmAwoZVgF6kilywz0Vo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2012, Roland Stigge wrote:
> In the above case, the situation is as follows:
> 
> * NXP has LPC3220, LPC3230, LPC3240 and LPC3250 (differing in SRAM size
>   and in the existence of its Ethernet and LCD controllers)
> * The ADC controller is present in every single one of those
> * We already have "lpc32xx" in the kernel everywhere
> * Current state is that NXP isn't planning to issue LPC32xx without ADC
> * I'm providing a lpc32xx.dtsi file to be used by all LPC32xx variants.
>   This one is referencing the above "compatible" string. Splitting up
>   in all possible numbers (see below) doesn't help much, here.
> 
> What would you prefer?
> 
> +static const struct of_device_id lpc32xx_adc_match[] = {
> +       { .compatible = "nxp,lpc3220-adc" },
> +       { .compatible = "nxp,lpc3230-adc" },
> +       { .compatible = "nxp,lpc3240-adc" },
> +       { .compatible = "nxp,lpc3250-adc" },
> +       {},
> +};

This looks ok to me.

> What is a better strategy here?

One way we sometimes do these things is to match only the earliest
model, e.g. nxp,lpc3220-adc, and put that one and the new model
into the device tree, to state the the device is compatible with
both the original implementation and the new one.

	Arnd
