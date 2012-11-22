Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2KVSaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:30:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:1321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab2KVS37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:29:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,300,1352102400"; 
   d="scan'208";a="251055637"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "Anton Vorontsov (anton.vorontsov@linaro.org)" 
	<anton.vorontsov@linaro.org>
CC: ??? <cw00.choi@samsung.com>, anish singh <anish198519851985@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myunjoo.ham@gmail.com" <myunjoo.ham@gmail.com>,
        "lockwood@android.com" <lockwood@android.com>,
        "peterhuewe@gmx.de" <peterhuewe@gmx.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: RE: Re: [PATCH] extcon : callback function to read cable property
Thread-Topic: Re: [PATCH] extcon : callback function to read cable property
Thread-Index: AQHNxw77phNNWr3n40Cie0eKpk7aUJf1E/rA
Date: Thu, 22 Nov 2012 13:00:52 +0000
Message-ID: <20ADAB092842284E95860F279283C564452531@BGSMSX101.gar.corp.intel.com>
References: <32212704.282601353409543335.JavaMail.weblogic@epml17>
In-Reply-To: <32212704.282601353409543335.JavaMail.weblogic@epml17>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAMIUQO8004082

> The "RFC" patch for this feature is now shown at:
> http://git.kernel.org/?p=linux/kernel/git/mzx/extcon.git;a=commit;h=5655a
> eef83addaec77a3b9387a3dd18b6c146dd5
> (Note that "for-add-feature" branch is sort of "RFC" branch)
> 
> I'm now considering relaying notifications of data updates possible via the
> notifier block of register-interest. Any inputs are welcomed.
> 
> 
> Anyway, for the USB issue of "suspend/resume at host-side and current-limit
> at device-side", we will need to 1. update regulator subsystem to have
> notification for current change (it does for enable/disable/voltage-changes)
> 2. let the charger use current-regulator 3. let the one who detects (usb
> driver?) changes at host-side change the current limit of that current-
> regulator 4. let the event from current-regulator relayed via extcon.
> We may use power-supply class as well for this issue. (may need to update if
> power-supply class does not have notifications and suspend/resume states)
> 

For this solution to work, the cable provider itself
need to register with any of these subsystems - power_supply/regulator/charger manager
IMHO a cable provider shouldn't register itself with any of the subsystem.

 For example it cannot register with power_supply subsystem
since it's not a power_supply. It's just source for a power_supply.
We register either charger/battery with power supply. I couldn't find a way
to register the cable with power supply subsystem. 

Anton,
Do you have any suggestion here?

I think the same case with regulator framework also. A cable doesn¡¯t belong
to a regulator framework. A cable doesn¡¯t expose any control attribute (current control/voltage
control). It just have  properties (eg current) controlled by external agents (Host machine/wall charger)

And charger manager is a consumer and not a provider. It cannot decide the charger cable capabilities.

I  have a modified version of the above patch which uses properties directly. 
https://gitorious.org/linux-charging-framework/linux-charging-framework/commit/ff358373dcb32027ebe1a267fc8b8999a3bd37e4

-jtc
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
