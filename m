Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab2L1XqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 18:46:01 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53001 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2L1Xp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 18:45:57 -0500
Message-ID: <50DE2F32.1010207@lwfinger.net>
Date: Fri, 28 Dec 2012 17:45:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: viresh kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix problem with cpufreq_pndemand or cpufreq_conservative
References: <50DE1A74.4040607@lwfinger.net> <3226192.H2BxHSuKio@vostro.rjw.lan>
In-Reply-To: <3226192.H2BxHSuKio@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2012 05:01 PM, Rafael J. Wysocki wrote:
> On Friday, December 28, 2012 04:17:24 PM Larry Finger wrote:
>> Since commit 2aacdff entitled "cpufreq: Move common part from governors to
>> separate file", whenever the drivers that depend on this new file
>> (cpufreq_ondemand or cpufreq_conservative) are built as modules, a new module
>> named cpufreq_governor is created. It seems that kmake is smart enough to create
>> a separate module whenever more than one module includes the same object file.
>> As drivers/cpufreq/cpufreq_governor.c contains no MODULE directives, the
>> resulting module has no license specified, which results in logging of a "module
>> license 'unspecified' taints kernel". In addition, a number of globals are
>> exported GPL only, and are therefore not available.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> This particular patch is the simplest possible; however, it hides the intent. I
>> have prepared the longer version that makes the reason clearer by adding a new
>> configuration variable that is dependent on the other two, and rearranges
>> drivers/cpufreq/Makefile. That version could be submitted if that is what is
>> desired.
>
> Yes, please.

I'll send it shortly.

>> The changes to cpufreq_governor.c are the same as in this version.
>
> I wonder if that's avoidable?  The intention is not to create an additional
> module, clearly.

It appears not to be possible. I don't know enough about to kmake to understand 
why it is forcing a new module. Perhaps some expert knows what Kconfig or 
Makefile magic will prevent that.

Larry



