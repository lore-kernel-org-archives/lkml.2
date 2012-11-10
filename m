Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2KJQxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 11:53:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47714 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2KJQxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 11:53:40 -0500
Message-ID: <509E8694.7080609@gmail.com>
Date: Sat, 10 Nov 2012 17:53:40 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rajanikanth H V <rajanikanth.hv@linaro.org>
CC: rob.herring@calxeda.com, lee.jones@linaro.org, arnd@arndb.de,
        anton.vorontsov@linaro.org, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
References: <1351698033-8980-1-git-send-email-rajanikanth.hv@linaro.org> <1351698033-8980-2-git-send-email-rajanikanth.hv@linaro.org> <509291FF.6090500@gmail.com> <alpine.DEB.2.02.1211072354150.5888@ubuntu12>
In-Reply-To: <alpine.DEB.2.02.1211072354150.5888@ubuntu12>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 07:45 PM, Rajanikanth H V wrote:
> On Thu, 1 Nov 2012, Francesco Lavra wrote:
> [...]
>>> +    btech = of_get_property(np_bat_supply,
>>> +        "stericsson,battery-type", NULL);
>>> +    if (!btech) {
>>> +        dev_warn(dev, "missing property battery-name/type\n");
>>> +        strcpy(bat_tech, "UNKNOWN");
>>> +    } else {
>>> +        strcpy(bat_tech, btech);
>>> +    }
>>
>> I don't get the point of declaring the char array and copying the string
>> in it, when you could simply use just the pointer returned by
>> of_get_property().
> 
> I am considering a corner case where in 'battery-type' property is not
> present and battery is connected.In this case i promote battery to
> UNKNOWN from null.

You could achieve the same result without using the char array, with
this assignment:

btech = "UNKNOWN";

> FYI: Further, btemp driver will identify the connected battery based on
> resistance value and decide to use.
> Ref: ab8500_btemp_id(...) ab8500_btemp.c
> 
>> Anyway, if the string property is longer than 8 characters, you are
>> writing past the size of the destination array.
> 
> i believe it is safe as power_supply.h comprises defines having battery
> technology type in 4 characters length which is normally the case and
> 7 chars length being "UNKNOWN" seldom referred

You should be able to handle whatever the device tree contains, and if
it contains unexpected data this is not a good excuse for locking up the
system.

--
Francesco
