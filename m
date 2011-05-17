Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1EQTSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:18:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44038 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab1EQTSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Mq+f/x5YKA0tpPfpWtHj3JogBRuIQWxlwTQ2XMkW6GqV89bF+P2xnJaEXfjZvnB9Al
         hw9iAledIlHnZWJtE2vip7WRjmFwO+ahxKEDecwnoGYazFO4M9jIcgLE8GAbwHJ0HT0e
         JDY11OVWYe3YGJUGHEkTrrDLhu7+YZImFgBYY=
Message-ID: <4DD2CA02.9040707@googlemail.com>
Date: Tue, 17 May 2011 21:18:26 +0200
From: Dirk Behme <dirk.behme@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Alessio Igor Bogani <abogani@kernel.org>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
References: <BANLkTi=2jW5PHB6QCaddHeZH0P=9PKWosw@mail.gmail.com> <1305577420-3685-1-git-send-email-abogani@kernel.org> <878vu6nftw.fsf@rustcorp.com.au>
In-Reply-To: <878vu6nftw.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.05.2011 05:52, Rusty Russell wrote:
> On Mon, 16 May 2011 22:23:40 +0200, Alessio Igor Bogani<abogani@kernel.org>  wrote:
>> This work was supported by a hardware donation from the CE Linux Forum.
>>
>> Signed-off-by: Alessio Igor Bogani<abogani@kernel.org>
>> ---
>>   kernel/module.c |    6 ++----
>>   1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 6a34337..54355c5 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -2055,10 +2055,8 @@ static const struct kernel_symbol *lookup_symbol(const char *name,
>>   	const struct kernel_symbol *stop)
>>   {
>>   	const struct kernel_symbol *ks = start;
>> -	for (; ks<  stop; ks++)
>> -		if (strcmp(ks->name, name) == 0)
>> -			return ks;
>> -	return NULL;
>> +	return bsearch(name, start, stop - start,
>> +			sizeof(struct kernel_symbol), cmp_name);
>>   }
>>
>>   static int is_exported(const char *name, unsigned long value,
>
> Applied.

Sorry, but where have you applied it?

With the version above we should get a warning

kernel/module.c: In function 'lookup_symbol':
kernel/module.c:1809: warning: unused variable 'ks'

?

Best regards

Dirk
