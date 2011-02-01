Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1BALgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 06:36:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:6989 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab1BALgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 06:36:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,409,1291622400"; 
   d="scan'208";a="702772316"
Date: Tue, 1 Feb 2011 12:36:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Arun MURTHY <arun.murthy@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: ab8500-gpadc Add new GPADC driver
Message-ID: <20110201113617.GB10128@sortiz-mobl>
References: <1295519304-27062-1-git-send-email-arun.murthy@stericsson.com>
 <4D382C9F.6000108@stericsson.com>
 <F45880696056844FA6A73F415B568C69537384B9F3@EXDCVYMBSTM006.EQ1STM.local>
 <4D39770C.20208@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D39770C.20208@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Fri, Jan 21, 2011 at 01:07:40PM +0100, Mattias Wallin wrote:
> On 01/21/2011 11:31 AM, Arun MURTHY wrote:
> > The only clients for GPADC is the battery driver and the Audio Acc
> > detection. Both of these are sub-modules/clients of ab8500.
> > None other than these can use the GPADC.
> > Inputs to GPADC can only be one among the following:
> > /* GPADC source: From datasheet(ADCSwSel[4:0] in GPADCCtrl2) */
> > #define BAT_CTRL        0x01
> > #define BTEMP_BALL      0x02
> > #define MAIN_CHARGER_V  0x03
> > #define ACC_DETECT1     0x04
> > #define ACC_DETECT2     0x05
> > #define ADC_AUX1		0x06
> > #define ADC_AUX2		0x07
> > #define MAIN_BAT_V      0x08
> > #define VBUS_V          0x09
> > #define MAIN_CHARGER_C  0x0A
> > #define USB_CHARGER_C   0x0B
> > #define BK_BAT_V        0x0C
> > #define DIE_TEMP        0x0D
> > 
> > Henceforth in order to secure the usage of GPADC, and in order to
> > restrict it to only EM and AUDIO sub-module, the gpadc device struct
> > was added to ab8500 struct. Also that the exported function
> > ab8500_gpadc_convert has an argument struct ab8500_gpadc, which can
> > be obtained be dereferencing the struct ab8500. This is possible only
> > with the ab8500 and its clients, thereby securing the usage to
> > battery driver and audio acc detect.
> Yes and I would like to remove this restriction and have a simpler more open api.
> First I don't like that users needs to do a lot of pointer dereferencing in their call like ab8500_gpadc_convert(dev->parent->ab8500->gpadc, USB_CHARGER) (an example).
>
As subdevices, I expect users to have an ab8500 pointer. So it would just be
one dereference.


> I prefer a get function that returns a handle that should be used as first argument in the convert calls.
> It also makes sense if this driver will be extended to use more channels.
> Second this driver will be used by for example accessories which likely will be called by 3 party drivers
> and to make their life easier I don't want to force them to this ab8500-core dependency.
>
As I'm not familiar with your HW architecture, could you please describe how
those accessories would wire into the ab8500 core ?
If those devices really are independent drivers (i.e. not subdevices) needing
to get an A/D conversion from the ab8500 adc (I don't see how that can happen,
hence my above question), then it might make sense to use a conversion API
independent from any ab8500 pointer. But otherwise, I prefer this API rather
than the one in v2 of this patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
