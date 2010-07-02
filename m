Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0GBJeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:34:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46679 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab0GBJe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uJ8RvBD8LUtNs7zwsdqiTy6XGGELjXf3kOUb7Wef6SVghhoLI6O+AVy6bzRbMGVER2
         /AEpU2V0idsCIvqvNxBq5VDf/94EbPIY7duhfBEPZ16mqNZbnkH9XykZAF5gOaMuHEP3
         kE1je1YBMc1ForTtbhMRbPC3+PBpGRWIk5dpk=
MIME-Version: 1.0
In-Reply-To: <AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
References: <AANLkTikeDE4hvZ3spyTBSHZsdQPc-2wlD5nTfb1aF-VD@mail.gmail.com>
	<20100702085323.GF10072@secunet.com>
	<AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
	<20100702091726.GH10072@secunet.com>
	<AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
Date: Fri, 2 Jul 2010 13:34:27 +0400
Message-ID: <AANLkTimTIWGJnPKWrQeqPCggXvhRBHYL6TniYsHC-_d5@mail.gmail.com>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
From: Dan Kruchinin <dan.kruchinin@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 1:32 PM, Dan Kruchinin <dan.kruchinin@gmail.com> wrote:
> On Fri, Jul 2, 2010 at 1:17 PM, Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
>> On Fri, Jul 02, 2010 at 01:07:44PM +0400, Dan Kruchinin wrote:
>>> >
>>> ...
>>
>> But the active cpumask, and now also your serial cpumask might change.
>> We need to catch this changes somehow, that's why I checked the active
>> cpumask against the callback cpu.
>
> You're right, now I get it. Hence the right solution is to check if
> callback CPU is set in serial cpumask every time we do
> padata_do_serial and if it's not, recalculate its value.

padata_do_parallel of course.

> The only thing that embarrasses me in this scheme is the fact that we
> have to allocate cpumask_var_t in pcrypt_do_parallel every time we
> call it then copy serial cpumask into allocated one and then check the
> cb_cpu.
> I think it would be better if we somehow could avoid dynamic cpumask
> allocation. I see the following solutions:
>
> 1) Do the check and cb_cpu value recalculation in padata_do_parallel.
> It may check if cb_cpu is in serial_cpumask and recalculate its value
> if it isn't. The drawback of this scheme is that padata_do_parallel
> now doesn't guaranty it will forward serialization job to the same
> callback CPU we passed to it. If passed CPU is not in serial cpumask
> it will forward serialization to another CPU and we won't know its
> number. The only thing we'll know is that this CPU is in the
> serial_cpumask.
> 2) Create new structure describing pcrypt instance in pcrypt.c which
> will include waitqueue, padata instance and preallocated cpumask which
> will be used for getting padata instance serial cpumsak. It'll help to
> avoid dynamic cpumask allocation but it looks a bit awkward.
>
>>
>> Steffen
>>
>>
>
>
>
> --
> W.B.R.
> Dan Kruchinin
>



-- 
W.B.R.
Dan Kruchinin
