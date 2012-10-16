Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab2JPDjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 23:39:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61743 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab2JPDjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 23:39:16 -0400
MIME-Version: 1.0
In-Reply-To: <5507518.Gae5ZRnSWO@vostro.rjw.lan>
References: <51be8f865e4c80f91ac8e41e54cbd5905382ddb7.1349844049.git.viresh.kumar@linaro.org>
	<5507518.Gae5ZRnSWO@vostro.rjw.lan>
Date: Tue, 16 Oct 2012 09:09:15 +0530
Message-ID: <CAKohpomJcN3aLefUOhJ+28PkqhjzKU9Qjk43xMTxhvvBNf8G+Q@mail.gmail.com>
Subject: Re: [PATCH] cpufreq:core: Fix printing of governor and driver name
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Sudeep.KarkadaNagesha@arm.com,
        Robin.Randhawa@arm.com, Arvind.Chauhan@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 October 2012 23:21, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday 10 of October 2012 10:12:11 Viresh Kumar wrote:
>> Arrays for governer and driver name are of size CPUFREQ_NAME_LEN or 16.
>> i.e. 15 bytes for name and 1 for trailing '\0'.
>>
>> When cpufreq driver print these names (for sysfs), it includes '\n' or ' ' in
>> the fmt string and still passes length as CPUFREQ_NAME_LEN. If the driver or
>> governor names are using all 15 fields allocated to them, then the trailing '\n'
>> or ' ' will never be printed. And so commands like:
>>
>> root@linaro-developer# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver
>>
>> will print something like:
>>
>> cpufreq_foodrvroot@linaro-developer#
>>
>> Fix this by increasing print length by one character.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Thanks for the patch, I'll queue it up for v3.8.

Hi Rafael,

Thanks for accepting the patch.
I thought both of my patches would go in 3.7-rc2 as they are bug
fixes. Isn't that correct?

--
viresh
