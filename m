Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2E2LKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 07:10:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2E2LKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 07:10:36 -0400
Message-ID: <4FC4AEA6.2090209@linaro.org>
Date: Tue, 29 May 2012 16:40:30 +0530
From: Avik Sil <avik.sil@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Use /usr/bin/pager if available for perf pager
References: <1338287725-26382-1-git-send-email-avik.sil@linaro.org> <20120529114506.7c8d6157@pyramind.ukuu.org.uk>
In-Reply-To: <20120529114506.7c8d6157@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Tuesday 29 May 2012 04:15 PM, Alan Cox wrote:
> On Tue, 29 May 2012 16:05:25 +0530
> Avik Sil<avik.sil@linaro.org>  wrote:
>
>> Some Distributions may lack "less" package being included by default, e.g., Linaro nano rootfs. In those cases use the portable "pager" command instead of "less".
>>
>> Signed-off-by: Avik Sil<avik.sil@linaro.org>
>> ---
>>   tools/perf/util/pager.c |    4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
>> index 1915de2..3322b84 100644
>> --- a/tools/perf/util/pager.c
>> +++ b/tools/perf/util/pager.c
>> @@ -57,6 +57,10 @@ void setup_pager(void)
>>   	}
>>   	if (!pager)
>>   		pager = getenv("PAGER");
>> +	if (!pager) {
>> +		if (!access("/usr/bin/pager", X_OK))
>> +			pager = "/usr/bin/pager";
>> +	}
>
> What is "portable" about /usr/bin/pager ? and what is wrong with just
> doing
>
> export PAGER=/usr/bin/pager
>
This patch basically avoids explicitly setting PAGER=/usr/bin/pager 
before running say 'perf list' on the system where less is not installed.

Regards,
Avik
