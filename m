Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab2KGSqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:46:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54898 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2KGSqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:46:14 -0500
Date: Thu, 8 Nov 2012 00:15:47 +0530 (IST)
From: Rajanikanth H V <rajanikanth.hv@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
cc: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>, rob.herring@calxeda.com,
        lee.jones@linaro.org, arnd@arndb.de, anton.vorontsov@linaro.org,
        linus.walleij@stericsson.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, STEricsson_nomadik_linux@list.st.com,
        rajanikanth.hv@stericsson.com
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
In-Reply-To: <509291FF.6090500@gmail.com>
Message-ID: <alpine.DEB.2.02.1211072354150.5888@ubuntu12>
References: <1351698033-8980-1-git-send-email-rajanikanth.hv@linaro.org> <1351698033-8980-2-git-send-email-rajanikanth.hv@linaro.org> <509291FF.6090500@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Francesco Lavra wrote:
[...]
>> +	btech = of_get_property(np_bat_supply,
>> +		"stericsson,battery-type", NULL);
>> +	if (!btech) {
>> +		dev_warn(dev, "missing property battery-name/type\n");
>> +		strcpy(bat_tech, "UNKNOWN");
>> +	} else {
>> +		strcpy(bat_tech, btech);
>> +	}
>
> I don't get the point of declaring the char array and copying the string
> in it, when you could simply use just the pointer returned by
> of_get_property().

I am considering a corner case where in 'battery-type' property is not
present and battery is connected.In this case i promote battery to
UNKNOWN from null.
FYI: Further, btemp driver will identify the connected battery based on
resistance value and decide to use.
Ref: ab8500_btemp_id(...) ab8500_btemp.c

> Anyway, if the string property is longer than 8 characters, you are
> writing past the size of the destination array.

i believe it is safe as power_supply.h comprises defines having battery
technology type in 4 characters length which is normally the case and
7 chars length being "UNKNOWN" seldom referred

