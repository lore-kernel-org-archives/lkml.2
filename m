Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2IMJDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:03:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48724 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339Ab2IMJDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:03:13 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAK44p21WAmcvFFqVOwhUfT8onR9QxgTPcAM8ernRGtw4s396bw@mail.gmail.com>
References: <20120912184644.48e4e2e7d59b12893a42f60a@canb.auug.org.au>
	<5050CF0E.3080502@xenotime.net>
	<CAK44p21WAmcvFFqVOwhUfT8onR9QxgTPcAM8ernRGtw4s396bw@mail.gmail.com>
Date: Thu, 13 Sep 2012 11:03:10 +0200
Message-ID: <CA+icZUX4Q0zLX4=oM5MUsefvQUVz7nDv0R01AOYNFurYYP3T8g@mail.gmail.com>
Subject: Re: [PATCH -next] thermal: cpu_cooling.c needs to select CPU_FREQ_TABLE
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Amit Kachhap <amit.kachhap@linaro.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 10:46 AM, Amit Kachhap <amit.kachhap@linaro.org> wrote:
> On 13 September 2012 03:06, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> cpu_cooling.c (CONFIG_CPU_THERMAL) uses cpu frequency table
>> intefaces so it should select CPU_FREQ_TABLE.
>> Fixes these build errors:
>>
>> drivers/built-in.o: In function `cpufreq_get_max_state':
>> cpu_cooling.c:(.text+0x4e1297): undefined reference to `cpufreq_frequency_get_table'
>> drivers/built-in.o: In function `cpufreq_set_cur_state':
>> cpu_cooling.c:(.text+0x4e138b): undefined reference to `cpufreq_frequency_get_table'
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> Cc: Amit Daniel <amit.kachhap@linaro.org>

Feel free to add:

      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

>> ---
>>  drivers/thermal/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> Also, please add info in the MAINTAINERS file for drivers/thermal/.
>>
>> --- linux-next-20120912.orig/drivers/thermal/Kconfig
>> +++ linux-next-20120912/drivers/thermal/Kconfig
>> @@ -22,6 +22,7 @@ config THERMAL_HWMON
>>  config CPU_THERMAL
>>         bool "generic cpu cooling support"
>>         depends on THERMAL && CPU_FREQ
>> +       select CPU_FREQ_TABLE
>
> This change looks good to me. Even similar select is present platform
> cpufreq drivers which uses the cpufreq API's.
>
> Thanks,
> Amit Daniel
>>         help
>>           This implements the generic cpu cooling mechanism through frequency
>>           reduction, cpu hotplug and any other ways of reducing temperature. An
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
