Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966135Ab0CPKYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:24:42 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53425 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966062Ab0CPKYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:24:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=s7mdlihZsIk+7gKScYaPwAfCE8JGuShjnvQtoiNYXMuCs551D05uIisKw8jKT3mK2Q
         MFS6kVos6bxrU2WGGFbYSPSufiWJSRWulkvkFqFNWDCqgnIrL2wE1vgYmBWUg1WTnrqY
         n14CUjJvwFB6E78l9YKT2LMCXDrGeyByD7/wc=
Message-ID: <4B9F5C64.4020807@gmail.com>
Date: Tue, 16 Mar 2010 12:24:36 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] perf: install into /usr/local by default.
References: <4B9F3EEC.7050104@gmail.com> <1268733435-30225-1-git-send-email-edwintorok@gmail.com> <20100316101031.GL7961@elte.hu>
In-Reply-To: <20100316101031.GL7961@elte.hu>
X-Enigmail-Version: 0.95.0
OpenPGP: id=5379965D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 12:10 PM, Ingo Molnar wrote:
> * T??r??k Edwin <edwintorok@gmail.com> wrote:
> 
>> It was confusing to install into $(HOME)/bin, especially since there was
>> no documentation mentioning where perf gets installed by default.
>> So install to /usr/local by default, as other programs do, and allow users to
>> override the install location by specifying the prefix explicitly.
>>
>> Signed-off-by: T??r??k Edwin <edwintorok@gmail.com>
>> ---
>>  tools/perf/Makefile |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>> index 2e7fa3a..8e8c199 100644
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> @@ -216,7 +216,7 @@ STRIP ?= strip
>>  # runtime figures out where they are based on the path to the executable.
>>  # This can help installing the suite in a relocatable way.
>>  
>> -prefix = $(HOME)
>> +prefix = /usr/local
>>  bindir_relative = bin
>>  bindir = $(prefix)/$(bindir_relative)
>>  mandir = share/man
> 
> Btw., we inherited that default prefix from the Git project.
> 
> Is there a way to get it into ~/bin/ if the user does not have permission to 
> /usr/local ? (i.e. doesnt run it as root)

That is complicated, I usually run make as a normal user, and only do
make install as root (or sudo make install).
I do that for the kernel itself, and usually every program I build (I
don't like compiling as root).

> 
> That's a really convenient aspect of doing a 'make install' as user. (Which i 
> tend to do in most cases)

On 03/16/2010 12:20 PM, Avi Kivity wrote:
> What about people (like me) who do 'make && sudo make install'?
>
> Can we make it position independent and derive the path from /proc/$$/exe?
>

There is a RUNTIME_PREFIX define (undocumented...) that seems to do
something like that.
Are there any security implications of using that by default?

Best regards,
--Edwin
