Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2GaPJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:09:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55340 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2GaPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:09:12 -0400
Message-ID: <5017F514.4030106@linaro.org>
Date: Tue, 31 Jul 2012 16:09:08 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/5] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
References: <1343745944-18418-1-git-send-email-lee.jones@linaro.org> <1343745944-18418-2-git-send-email-lee.jones@linaro.org> <20120731145614.GZ4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120731145614.GZ4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 15:56, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 03:45:40PM +0100, Lee Jones wrote:
>> If a list of widgets is provided and one of them fails to be added as
>> a control, the present semantics fail all subsequent widgets. A better
>> solution would be to only fail that widget, but pursue in attempting
>> to add the rest of the list.
>
> To reiterate, this is in *no* way urgent or even a bug fix.

It fixes sound in our driver.

Without this the card failes to instantiate.

>>   			dev_err(dapm->dev,
>>   				"ASoC: Failed to create DAPM control %s\n",
>>   				widget->name);
>> -			ret = -ENOMEM;
>> -			break;
>
> Indeed, removing the error return is a regression.

Isn't the return code incorrect? There are a multitude of reasons why 
snd_soc_dapm_new_control() would fail. No-memory is just one of them, so 
why do we force this probable lie?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
