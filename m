Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1AaCZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 21:25:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1AaCZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:25:14 -0500
Message-ID: <4D461D5C.6090401@redhat.com>
Date: Mon, 31 Jan 2011 10:24:28 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] kmap_atomic: remove the second parameter
References: <1296380820-8801-1-git-send-email-amwang@redhat.com> <20110130103348.GA2528@joi.lan>
In-Reply-To: <20110130103348.GA2528@joi.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年01月30日 18:33, Marcin Slusarz 写道:
> On Sun, Jan 30, 2011 at 05:46:57PM +0800, Amerigo Wang wrote:
>>
>> (...)
>>
>> diff --git a/sound/oss/Makefile b/sound/oss/Makefile
>> index 96f14dc..90ffb99 100644
>> --- a/sound/oss/Makefile
>> +++ b/sound/oss/Makefile
>> @@ -87,7 +87,7 @@ ifeq ($(CONFIG_PSS_HAVE_BOOT),y)
>>   	$(obj)/bin2hex pss_synth<  $<  >  $@
>>   else
>>       $(obj)/pss_boot.h:
>> -	(							\
>> +	$(Q)(							\
>>   	    echo 'static unsigned char * pss_synth = NULL;';	\
>>   	    echo 'static int pss_synthLen = 0;';		\
>>   	)>  $@
>> @@ -102,7 +102,7 @@ ifeq ($(CONFIG_TRIX_HAVE_BOOT),y)
>>   	$(obj)/hex2hex -i trix_boot<  $<  >  $@
>>   else
>>       $(obj)/trix_boot.h:
>> -	(							\
>> +	$(Q)(							\
>>   	    echo 'static unsigned char * trix_boot = NULL;';	\
>>   	    echo 'static int trix_boot_len = 0;';		\
>>   	)>  $@
>> --
>
> does it belong here?
>

Oh, of course not. My bad, I forgot to revert the previous patch before
making this one! :(

Thanks!
