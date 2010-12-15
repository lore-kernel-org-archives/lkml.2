Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0LOVaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:30:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57323 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab0LOVaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:30:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uFj9y6ggGSk0EAtRgF1pBXYTtQW4Ym/a6JY+QmcqYONMCp1a5IYepOrkrxiiNLbGoV
         gXDKqOI0apJZEorPLwITtmkwETEaClHQuF1xzAo335fztf940jwDTPp7ETLC9zbbTCNQ
         RVnS0nhSyzuShdP88Ra5WRgl38rCzqqehjLcg=
MIME-Version: 1.0
In-Reply-To: <4D092D15.7030700@zytor.com>
References: <alpine.DEB.2.00.1012151404070.21102@router.home>
	<20101215125626.25f7d648.akpm@linux-foundation.org>
	<4D092D15.7030700@zytor.com>
Date: Wed, 15 Dec 2010 22:30:05 +0100
Message-ID: <AANLkTimhdmWGhxW9qnFWYxiVDManH4XG4RqTLJb_Fdbk@mail.gmail.com>
Subject: Re: x86: A fast way to check capabilities of the current cpu
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enbeerg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 10:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/15/2010 12:56 PM, Andrew Morton wrote:
>> On Wed, 15 Dec 2010 14:07:39 -0600 (CST)
>> Christoph Lameter <cl@linux.com> wrote:
>>
>>> +#define cpu_has(c, bit)                                                     \
>>> +    (__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :  \
>>>       test_cpu_cap(c, bit))
>>>
>>> +#define this_cpu_has(bit)                                           \
>>> +    (__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :  \
>>> +     this_cpu_test_bit(bit, (unsigned long *)&cpu_info.x86_capability))
>>> +
>>
>> Isn't
>>
>>       a ? 1 : b
>>
>> a complex way of writing
>>
>>       a || b
>>
>
> Not if b is not a bool.
>

In this case it this_cpu_*_test_bit() return an int, but they act as a
bool and are used in if()s; where is the catch?

>        -hpa
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
