Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1AUKcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:32:12 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:36128 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab1AUKcK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:32:10 -0500
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Mattias WALLIN <mattias.wallin@stericsson.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Date: Fri, 21 Jan 2011 11:31:31 +0100
Subject: RE: [PATCH] mfd: ab8500-gpadc Add new GPADC driver
Thread-Topic: [PATCH] mfd: ab8500-gpadc Add new GPADC driver
Thread-Index: Acu4ntqsppBlhN/xTeOpssE10N5htQAtfoKA
Message-ID: <F45880696056844FA6A73F415B568C69537384B9F3@EXDCVYMBSTM006.EQ1STM.local>
References: <1295519304-27062-1-git-send-email-arun.murthy@stericsson.com>
 <4D382C9F.6000108@stericsson.com>
In-Reply-To: <4D382C9F.6000108@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > + * ab8500_gpadc_convert() - gpadc conversion
> > + * @input:	analog input to be converted to digital data
> > + *
> > + * This function converts the selected analog i/p to digital
> > + * data. Thereafter calibration has to be made to obtain the
> > + * data in the required quantity measurement.
> > + */
> > +int ab8500_gpadc_convert(struct ab8500_gpadc *di, u8 input)
> I would like this interface to change in order to remove the struct
> ab8500_gpadc
> from the struct ab8500. I.e not restrict the users to subdriver of
> ab8500.

The only clients for GPADC is the battery driver and the Audio Acc
detection. Both of these are sub-modules/clients of ab8500.
None other than these can use the GPADC.
Inputs to GPADC can only be one among the following:
/* GPADC source: From datasheet(ADCSwSel[4:0] in GPADCCtrl2) */
#define BAT_CTRL        0x01
#define BTEMP_BALL      0x02
#define MAIN_CHARGER_V  0x03
#define ACC_DETECT1     0x04
#define ACC_DETECT2     0x05
#define ADC_AUX1		0x06
#define ADC_AUX2		0x07
#define MAIN_BAT_V      0x08
#define VBUS_V          0x09
#define MAIN_CHARGER_C  0x0A
#define USB_CHARGER_C   0x0B
#define BK_BAT_V        0x0C
#define DIE_TEMP        0x0D

Henceforth in order to secure the usage of GPADC, and in order to
restrict it to only EM and AUDIO sub-module, the gpadc device struct
was added to ab8500 struct. Also that the exported function
ab8500_gpadc_convert has an argument struct ab8500_gpadc, which can
be obtained be dereferencing the struct ab8500. This is possible only
with the ab8500 and its clients, thereby securing the usage to
battery driver and audio acc detect.

Thanks and Regards,
Arun R Murthy
-------------
