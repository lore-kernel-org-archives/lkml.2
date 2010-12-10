Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0LJI1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:27:40 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:44904 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab0LJI1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:27:39 -0500
Message-ID: <4D01E46C.90301@stericsson.com>
Date: Fri, 10 Dec 2010 09:27:24 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500-core chip version cut 2.0 support
References: <1291717247-10280-1-git-send-email-mattias.wallin@stericsson.com> <20101209170851.GZ8884@sortiz-mobl>
In-Reply-To: <20101209170851.GZ8884@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/09/2010 06:08 PM, Samuel Ortiz wrote:
> Hi Mattias,
> 
> On Tue, Dec 07, 2010 at 11:20:47AM +0100, Mattias Wallin wrote:
>> This patch adds support for chip version 2.0 or cut 2.0.
>> One new interrupt latch register - latch 12 - is introduced.
> One question for you:
> 
>> diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
>> index 1848781..157f000 100644
>> --- a/include/linux/mfd/ab8500.h
>> +++ b/include/linux/mfd/ab8500.h
>> @@ -74,30 +74,37 @@
>>  #define AB8500_INT_ACC_DETECT_21DB_F	37
>>  #define AB8500_INT_ACC_DETECT_21DB_R	38
>>  #define AB8500_INT_GP_SW_ADC_CONV_END	39
>> -#define AB8500_INT_BTEMP_LOW		72
>> -#define AB8500_INT_BTEMP_LOW_MEDIUM	73
>> -#define AB8500_INT_BTEMP_MEDIUM_HIGH	74
>> -#define AB8500_INT_BTEMP_HIGH		75
>> -#define AB8500_INT_USB_CHARGER_NOT_OK	81
>> -#define AB8500_INT_ID_WAKEUP_R		82
>> -#define AB8500_INT_ID_DET_R1R		84
>> -#define AB8500_INT_ID_DET_R2R		85
>> -#define AB8500_INT_ID_DET_R3R		86
>> -#define AB8500_INT_ID_DET_R4R		87
>> -#define AB8500_INT_ID_WAKEUP_F		88
>> -#define AB8500_INT_ID_DET_R1F		90
>> -#define AB8500_INT_ID_DET_R2F		91
>> -#define AB8500_INT_ID_DET_R3F		92
>> -#define AB8500_INT_ID_DET_R4F		93
>> -#define AB8500_INT_USB_CHG_DET_DONE	94
>> -#define AB8500_INT_USB_CH_TH_PROT_F	96
>> -#define AB8500_INT_USB_CH_TH_PROT_R	97
>> -#define AB8500_INT_MAIN_CH_TH_PROT_F	98
>> -#define AB8500_INT_MAIN_CH_TH_PROT_R	99
>> -#define AB8500_INT_USB_CHARGER_NOT_OKF	103
>> +#define AB8500_INT_ADP_SOURCE_ERROR	72
>> +#define AB8500_INT_ADP_SINK_ERROR	73
>> +#define AB8500_INT_ADP_PROBE_PLUG	74
>> +#define AB8500_INT_ADP_PROBE_UNPLUG	75
>> +#define AB8500_INT_ADP_SENSE_OFF	76
>> +#define AB8500_INT_USB_PHY_POWER_ERR	78
>> +#define AB8500_INT_USB_LINK_STATUS	79
>> +#define AB8500_INT_BTEMP_LOW		80
>> +#define AB8500_INT_BTEMP_LOW_MEDIUM	81
>> +#define AB8500_INT_BTEMP_MEDIUM_HIGH	82
>> +#define AB8500_INT_BTEMP_HIGH		83
>> +#define AB8500_INT_USB_CHARGER_NOT_OK	89
>> +#define AB8500_INT_ID_WAKEUP_R		90
>> +#define AB8500_INT_ID_DET_R1R		92
>> +#define AB8500_INT_ID_DET_R2R		93
>> +#define AB8500_INT_ID_DET_R3R		94
>> +#define AB8500_INT_ID_DET_R4R		95
>> +#define AB8500_INT_ID_WAKEUP_F		96
>> +#define AB8500_INT_ID_DET_R1F		98
>> +#define AB8500_INT_ID_DET_R2F		99
>> +#define AB8500_INT_ID_DET_R3F		100
>> +#define AB8500_INT_ID_DET_R4F		101
>> +#define AB8500_INT_USB_CHG_DET_DONE	102
>> +#define AB8500_INT_USB_CH_TH_PROT_F	104
>> +#define AB8500_INT_USB_CH_TH_PROT_R    105
>> +#define AB8500_INT_MAIN_CH_TH_PROT_F   106
>> +#define AB8500_INT_MAIN_CH_TH_PROT_R	107
>> +#define AB8500_INT_USB_CHARGER_NOT_OKF	111
> This new interrupt sources layout doesn't seem to be compatible with the
> current one. What's the story here ?
The above list of interrupts must match the latch register array (ab8500_irq_regoffset) that the interrupt handler of ab8500-core uses.
Now, our HW guys added a new latch register in the middle of the other registers so I had to insert the eight new interrupts in the middle of above list.
But it should not be any problems for the sub drivers since all uses above defines and platform_get_ioresource().
Did I answer your question or did I answer another question?

/Wallin
