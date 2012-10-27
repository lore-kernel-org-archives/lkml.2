Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab2J0QQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:16:51 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33614 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab2J0QQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:16:49 -0400
Message-ID: <508C096B.6060902@gmail.com>
Date: Sat, 27 Oct 2012 18:18:51 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rajanikanth HV <rajanikanth.hv@linaro.org>
CC: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        linaro-dev@lists.linaro.org, linus.walleij@stericsson.com,
        arnd@arndb.de, patches@linaro.org, linux-kernel@vger.kernel.org,
        anton.vorontsov@linaro.org, STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
References: <1351146654-9110-1-git-send-email-rajanikanth.hv@stericsson.com> <1351146654-9110-2-git-send-email-rajanikanth.hv@stericsson.com> <508BF8A8.9090206@gmail.com> <CAB4BAkuPE6eSr2+LWTaV9trOnFk-_yt-+x8f6zpum=Ws1UvmmA@mail.gmail.com>
In-Reply-To: <CAB4BAkuPE6eSr2+LWTaV9trOnFk-_yt-+x8f6zpum=Ws1UvmmA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2012 06:00 PM, Rajanikanth HV wrote:
> On 27 October 2012 20:37, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
>> On 10/25/2012 08:30 AM, Rajanikanth H.V wrote:
>>> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
>>> +     bat_tech = of_get_property(np_bat_supply,
>>> +                     "stericsson,battery-type", NULL);
>>> +     if (!bat_tech)
>>> +             dev_warn(dev, "missing property battery-name/type\n");
>>> +
>>> +     if (strncmp(bat_tech, "LION", 4) == 0) {
>>
>> What if bat_tech is NULL?
> It will be UNKNOWN

I wanted to draw your attention to the fact that if bat_tech is NULL you
are passing a NULL pointer to strncmp(), which is not good.
So you should assign a default value to bat_tech in case the battery
type property is not found in the DT, as below:

if (!bat_tech) {
	dev_warn(dev, "missing property battery-name/type\n");
	bat_tech = "UNKNOWN";
}

--
Francesco
