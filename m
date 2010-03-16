Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966114Ab0CPKVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:21:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966062Ab0CPKVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:21:01 -0400
Message-ID: <4B9F5B6E.5040302@redhat.com>
Date: Tue, 16 Mar 2010 12:20:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: T??r??k Edwin <edwintorok@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: install into /usr/local by default.
References: <4B9F3EEC.7050104@gmail.com> <1268733435-30225-1-git-send-email-edwintorok@gmail.com> <20100316101031.GL7961@elte.hu>
In-Reply-To: <20100316101031.GL7961@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 12:10 PM, Ingo Molnar wrote:
> * T??r??k Edwin<edwintorok@gmail.com>  wrote:
>
>    
>> It was confusing to install into $(HOME)/bin, especially since there was
>> no documentation mentioning where perf gets installed by default.
>> So install to /usr/local by default, as other programs do, and allow users to
>> override the install location by specifying the prefix explicitly.
>>
>> Signed-off-by: T??r??k Edwin<edwintorok@gmail.com>
>> ---
>>   tools/perf/Makefile |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>> index 2e7fa3a..8e8c199 100644
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> @@ -216,7 +216,7 @@ STRIP ?= strip
>>   # runtime figures out where they are based on the path to the executable.
>>   # This can help installing the suite in a relocatable way.
>>
>> -prefix = $(HOME)
>> +prefix = /usr/local
>>   bindir_relative = bin
>>   bindir = $(prefix)/$(bindir_relative)
>>   mandir = share/man
>>      
> Btw., we inherited that default prefix from the Git project.
>
> Is there a way to get it into ~/bin/ if the user does not have permission to
> /usr/local ? (i.e. doesnt run it as root)
>
> That's a really convenient aspect of doing a 'make install' as user. (Which i
> tend to do in most cases)
>    

What about people (like me) who do 'make && sudo make install'?

Can we make it position independent and derive the path from /proc/$$/exe?

-- 
error compiling committee.c: too many arguments to function

