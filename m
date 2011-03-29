Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1C2SGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:06:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63385 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1C2SGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:06:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LosQG3mmpSQ74oehtu/BVS53zvfEUJKZt7JGdx35pql8yD5QYTJ/UMyzvmuP94Ba/7
         /bWpMzT7or+g/gk4G3mB7rc7vULJRvDTeMzshb6YoYk/n2jSb0lJg2iRRF/IPlTFcwwh
         5lPwbPs7xPfgUbXUYAV8JwbRntUZSEE0r19qU=
Message-ID: <4D921FA9.4000909@gmail.com>
Date: Tue, 29 Mar 2011 11:06:33 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110316 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: trivial@kernel.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH]arch:Kconfig.locks Remove unused config option.
References: <1301416611-3651-1-git-send-email-justinmattock@gmail.com> <20110329175302.GF8529@home.goodmis.org>
In-Reply-To: <20110329175302.GF8529@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 10:53 AM, Steven Rostedt wrote:
> On Tue, Mar 29, 2011 at 09:36:51AM -0700, Justin P. Mattock wrote:
>> using a cleanup script I found this, could be real/fake not sure
>> I grepped the whole kernel and only found this. If/when you have
>> time let me know..
>
> This was added by: 36cd3c9f925b9307236505ae7ad1ad7ac4d4357c
> mutex: have non-spinning mutexes on s390 by default
>
> and removed by: fa188ae1657d6edc7963d524ce9a0650fe725242
> [S390] mutex: enable spinning mutex on s390
>
> So I think you are safe in removing it.
>
> Thanks!
>
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> Acked-by: Steven Rostedt<rostedt@goodmis.org>
>
> -- Steve
>

o.k... a bit confusing with some of these, but good learning!!

>>
>> ---
>>   arch/Kconfig         |    3 ---
>>   kernel/Kconfig.locks |    2 +-
>>   2 files changed, 1 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index f78c2be..8d24bac 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -144,9 +144,6 @@ config HAVE_CLK
>>   config HAVE_DMA_API_DEBUG
>>   	bool
>>
>> -config HAVE_DEFAULT_NO_SPIN_MUTEXES
>> -	bool
>> -
>>   config HAVE_HW_BREAKPOINT
>>   	bool
>>   	depends on PERF_EVENTS
>> diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
>> index 88c92fb..5e62baf 100644
>> --- a/kernel/Kconfig.locks
>> +++ b/kernel/Kconfig.locks
>> @@ -199,4 +199,4 @@ config INLINE_WRITE_UNLOCK_IRQRESTORE
>>   	def_bool !DEBUG_SPINLOCK&&  ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
>>
>>   config MUTEX_SPIN_ON_OWNER
>> -	def_bool SMP&&  !DEBUG_MUTEXES&&  !HAVE_DEFAULT_NO_SPIN_MUTEXES
>> +	def_bool SMP&&  !DEBUG_MUTEXES
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>

