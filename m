Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1AUMHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 07:07:53 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:58557 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012Ab1AUMHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 07:07:49 -0500
Message-ID: <4D39770C.20208@stericsson.com>
Date: Fri, 21 Jan 2011 13:07:40 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: ab8500-gpadc Add new GPADC driver
References: <1295519304-27062-1-git-send-email-arun.murthy@stericsson.com> <4D382C9F.6000108@stericsson.com>  <F45880696056844FA6A73F415B568C69537384B9F3@EXDCVYMBSTM006.EQ1STM.local>
In-Reply-To: <F45880696056844FA6A73F415B568C69537384B9F3@EXDCVYMBSTM006.EQ1STM.local>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 11:31 AM, Arun MURTHY wrote:
> The only clients for GPADC is the battery driver and the Audio Acc
> detection. Both of these are sub-modules/clients of ab8500.
> None other than these can use the GPADC.
> Inputs to GPADC can only be one among the following:
> /* GPADC source: From datasheet(ADCSwSel[4:0] in GPADCCtrl2) */
> #define BAT_CTRL        0x01
> #define BTEMP_BALL      0x02
> #define MAIN_CHARGER_V  0x03
> #define ACC_DETECT1     0x04
> #define ACC_DETECT2     0x05
> #define ADC_AUX1		0x06
> #define ADC_AUX2		0x07
> #define MAIN_BAT_V      0x08
> #define VBUS_V          0x09
> #define MAIN_CHARGER_C  0x0A
> #define USB_CHARGER_C   0x0B
> #define BK_BAT_V        0x0C
> #define DIE_TEMP        0x0D
> 
> Henceforth in order to secure the usage of GPADC, and in order to
> restrict it to only EM and AUDIO sub-module, the gpadc device struct
> was added to ab8500 struct. Also that the exported function
> ab8500_gpadc_convert has an argument struct ab8500_gpadc, which can
> be obtained be dereferencing the struct ab8500. This is possible only
> with the ab8500 and its clients, thereby securing the usage to
> battery driver and audio acc detect.
Yes and I would like to remove this restriction and have a simpler more open api.
First I don't like that users needs to do a lot of pointer dereferencing in their call like ab8500_gpadc_convert(dev->parent->ab8500->gpadc, USB_CHARGER) (an example).
I prefer a get function that returns a handle that should be used as first argument in the convert calls.
It also makes sense if this driver will be extended to use more channels.
Second this driver will be used by for example accessories which likely will be called by 3 party drivers
and to make their life easier I don't want to force them to this ab8500-core dependency.
I agree however that the users must be in above list and most of them are ab8500 devices already.

Best Regards,
/Mattias Wallin
