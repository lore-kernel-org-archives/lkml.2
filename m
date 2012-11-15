Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767592Ab2KOLfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:35:24 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:60164 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993197Ab2KOLfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:35:23 -0500
Message-ID: <50A4D362.5060402@stericsson.com>
Date: Thu, 15 Nov 2012 17:04:58 +0530
From: Rajanikanth HV <rajanikanth.hv@stericsson.com>
Organization: st.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: Rajanikanth H V <rajanikanth.hv@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
References: <1351698033-8980-1-git-send-email-rajanikanth.hv@linaro.org> <1351698033-8980-2-git-send-email-rajanikanth.hv@linaro.org> <509291FF.6090500@gmail.com> <alpine.DEB.2.02.1211072354150.5888@ubuntu12> <509E8694.7080609@gmail.com>
In-Reply-To: <509E8694.7080609@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Saturday 10 November 2012 10:23 PM, Francesco Lavra wrote:
>>> I don't get the point of declaring the char array and copying the string
>>> in it, when you could simply use just the pointer returned by
>>> of_get_property().
>>
>> I am considering a corner case where in 'battery-type' property is not
>> present and battery is connected.In this case i promote battery to
>> UNKNOWN from null.
> 
> You could achieve the same result without using the char array, with
> this assignment:
> 
> btech = "UNKNOWN";
> 
>> FYI: Further, btemp driver will identify the connected battery based on
>> resistance value and decide to use.
>> Ref: ab8500_btemp_id(...) ab8500_btemp.c
>>
>>> Anyway, if the string property is longer than 8 characters, you are
>>> writing past the size of the destination array.
>>
>> i believe it is safe as power_supply.h comprises defines having battery
>> technology type in 4 characters length which is normally the case and
>> 7 chars length being "UNKNOWN" seldom referred
> 
> You should be able to handle whatever the device tree contains, and if
> it contains unexpected data this is not a good excuse for locking up the
> system.
agreed, if we were to go by what device tree contains then explicit
assignment for battery type as "UNKNOWN" is not required, hence only 2
use case persist as :
a) property name with one of the said value be present
	(as per documentation)
b) property name not present
