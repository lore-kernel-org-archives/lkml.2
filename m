Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab1BQN0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 08:26:48 -0500
Received: from www.tglx.de ([62.245.132.106]:51964 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab1BQN0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:26:47 -0500
Date: Thu, 17 Feb 2011 14:26:12 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: Re: [sodaville] [PATCH OF 13/14] rtc/cmos: add OF bindings
Message-ID: <20110217132612.GB13500@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-14-git-send-email-bigeasy@linutronix.de> <20110216221108.GJ22837@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20110216221108.GJ22837@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-02-16 15:11:08 [-0700]:

>> diff --git a/Documentation/powerpc/dts-bindings/rtc-cmos.txt b/Documentation/powerpc/dts-bindings/rtc-cmos.txt
>> new file mode 100644
>> index 0000000..7382989
>> --- /dev/null
>> +++ b/Documentation/powerpc/dts-bindings/rtc-cmos.txt
>
>Move to Documentation/devicetree/bindings/rtc/
moved.

>> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
>> index c7ff8df..2709e00 100644
>> --- a/drivers/rtc/rtc-cmos.c
>> +++ b/drivers/rtc/rtc-cmos.c
>> @@ -1162,6 +1205,9 @@ static struct platform_driver cmos_platform_driver = {
>>  #ifdef CONFIG_PM
>>  		.pm		= &cmos_pm_ops,
>>  #endif
>> +#if defined(CONFIG_OF)
>> +		.of_match_table = of_cmos_match,
>> +#endif
>
>The #if defined(CONFIG_OF) is no longer necessary around
>.of_match_table, particularly if you have a #else above that #defines
>of_cmos_match to NULL.

Kinda does not work. I get here:
|drivers/rtc/rtc-cmos.c:1209:3: error: unknown field ‘of_match_table’ specified in initializer

I rebased on top of -rc5. Is this something new you describing?

Sebastian
