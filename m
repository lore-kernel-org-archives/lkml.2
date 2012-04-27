Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab2D0HzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:55:01 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59811 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab2D0Hy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:54:59 -0400
Message-ID: <4F9A50BD.1090000@openvz.org>
Date: Fri, 27 Apr 2012 11:54:37 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/4] compiler.h: introduce unused_expression() macro
References: <20120425112623.26927.43229.stgit@zurg> <20120426153411.8686e0f9.akpm@linux-foundation.org>
In-Reply-To: <20120426153411.8686e0f9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 25 Apr 2012 15:26:23 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> Sometimes we want to check some expressions correctness in compile-time without
>> generating extra code. "(void)(e)" does not work if expression has side-effects.
>> This patch introduces macro unused_expression() which helps in this situation.
>>
>> Cast to "long" required because sizeof does not work for bit-fields.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> ---
>>   include/linux/compiler.h |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
>> index 923d093..46fbda3 100644
>> --- a/include/linux/compiler.h
>> +++ b/include/linux/compiler.h
>> @@ -310,4 +310,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>>    */
>>   #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
>>
>> +#define unused_expression(e) ((void)(sizeof((__force long)(e))))
>> +
>
> btw, please let's not add undocumented stuff, particularly obscure
> undocumented stuff.
>
> I typed this in:

Thanks!

>
> --- a/include/linux/compiler.h~compilerh-introduce-unused_expression-macro-fix
> +++ a/include/linux/compiler.h
> @@ -310,6 +310,11 @@ void ftrace_likely_update(struct ftrace_
>    */
>   #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
>
> +/*
> + * unused_expression() permits the compiler to check the validity of the
> + * expression but avoids the generation of any code, even if that expression
> + * has side-effects.
> + */
>   #define unused_expression(e) ((void)(sizeof((__force long)(e))))
>
>   #endif /* __LINUX_COMPILER_H */
>
> but then decided I didn't want to apply the patches (yet?).

I'm OK with that. But probably Hugh Dickins (now in CC) aggressively wants to
remove side-effects of VM_BUG_ON's in case CONFIG_DEBUG_VM=n

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

