Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087Ab0FQDOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 23:14:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49162 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab0FQDOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 23:14:07 -0400
Message-ID: <4C199267.4070109@cn.fujitsu.com>
Date: Thu, 17 Jun 2010 11:11:35 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Adam Schrotenboer <adam@tabris.net>
CC: mingo@elte.hu, linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: excluding "." and ".." directories when calculating
 tids.
References: <4C1740B1.9070806@cn.fujitsu.com> <4C1748D6.1020007@cn.fujitsu.com> <4C185F68.1020505@cn.fujitsu.com> <4C18FD5E.7070809@tabris.net>
In-Reply-To: <4C18FD5E.7070809@tabris.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Schrotenboer wrote:
> On 06/15/2010 10:21 PM, Gui Jianfeng wrote:
>> Introduce a filter function to skip "." and ".." directories when calculating
>> tid number.
>>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  tools/perf/util/thread.c |   11 ++++++++++-
>>  1 files changed, 10 insertions(+), 1 deletions(-)
>>
>> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
>> index 1f7ecd4..9a448b4 100644
>> --- a/tools/perf/util/thread.c
>> +++ b/tools/perf/util/thread.c
>> @@ -7,6 +7,15 @@
>>  #include "util.h"
>>  #include "debug.h"
>>  
>> +/* Skip "." and ".." directories */
>> +static int filter(const struct dirent *dir)
>> +{
>> +	if (dir->d_name[0] == '.')
>> +		return 0;
>> +	else
>> +		return 1;
>> +}
>> +
>>   
> 
> Is this safe? Can you _never_ have a d_name with a leading dot, like '
> .hidden' ??
> Maybe should
> if(dir->d_name[0] == '.' && (dir->d_name[1] == '\0' || (dir->d_name[1]
> == '.' && dir->d_name[2] == '\0')))
> 
> Admittedly I don't think it happens in the current procfs, but I'd want
> to be careful regardless.

Actually, we only care the numeral directories. So, even if there's a ".hidden",
it's fine to filter out this directory. Just keep things simple here.

Thanks,
Gui

> 
> 

