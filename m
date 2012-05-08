Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab2EHRQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:16:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:40637 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab2EHRQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:16:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97734830"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        ??? <cw00.choi@samsung.com>
Subject: RE: [PATCH v2] charger_manager: update charge profile upon
 temperature zone change
Thread-Topic: [PATCH v2] charger_manager: update charge profile upon
 temperature zone change
Thread-Index: AQHNLK2y4rIr96V0H02bTcfMJWXYepbAFasQ
Date: Tue, 8 May 2012 17:15:55 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD1426B2@BGSMSX102.gar.corp.intel.com>
References: <3331130.84351336435272215.JavaMail.weblogic@epml16>
In-Reply-To: <3331130.84351336435272215.JavaMail.weblogic@epml16>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="ks_c_5601-1987"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q48HGCm5027841

> > This patch allows the Charger-Manager to adjust the charging
> > parameters upon events like VBUS rise or drop and allows batteries to
> > have multiple charge profiles for different temperature zones.
> >
> > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> 
> I don't see how the parameters are changed when update_charger is true.
My initial thought was to keep these details hide from CM.

> Are you intending to do it at userspace after getting uevent_notify()? (I don't think
> it's good)
No, we will do it from driver only.

> If the intension is to update some of the charger-manager internal parameters (struct
> charger_manager's struct charger_desc) according to the temperature, we'd need a more
> general method that can also update values in the charger-manager context.
> 
> For example, instead of simply putting a callback to determine whether an update is
> required or not, a table of (including hysterisis) temperatures and values to be updated
> (or callbacks to update charger_desc based on the temperature) might be a starting
> point. You may also need to consider using notifier chain w/ temperatures.
> 
Yes I agree, I will submit another patch with these changes.

As part of charge enablement we generally program charge current, charge voltage
into the charger chip.

We can pass the charging parameters CC and CV in two ways.
1. Add these params in charger_desc struct and the  charger regulator can get these
params using container_of() call? but becomes complex.

2. use regulator_set_voltage()/regulator_set_current_limit() functions to set the CV and CC params.
but not suitable as is, we have add support in regulator framework

3. use regulator_get_drvdata()/regulator_set_drvdata() to set CC & CV params. These functions
allow us to add more params in future if required.

I am thinking of using option 3.

Let me know your feedback.

Thanks,
Ram

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
