Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1K1KLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:11:39 -0500
Received: from mx01.edigma.com ([195.22.21.235]:55517 "EHLO mx01.edigma.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1K1KLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:11:38 -0500
Message-ID: <4ED35E52.5010008@edigma.com>
Date: Mon, 28 Nov 2011 10:11:30 +0000
From: Nuno Santos <nsantos@edigma.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Floating point usage inside kernel
References: <S1754322Ab1KYK6W/20111125105822Z+929@vger.kernel.org> <4ECF789F.3040001@edigma.com> <4ECF8528.9080800@gmail.com> <4ECFBF56.4000002@edigma.com> <4ECFCAD5.5040606@grupopie.com> <4ECFD488.4060805@edigma.com> <4ECFDA1D.3090303@grupopie.com>
In-Reply-To: <4ECFDA1D.3090303@grupopie.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, understood!

Just one more question. To do this, do I need to change the data type 
from double to int?

Thanks,

Nuno

On 11/25/2011 06:10 PM, Paulo Marques wrote:
> Nuno Santos wrote:
>>> [...]
>>> Unless you have overflow or need more than 16 bits of fractional
>>> precision, you'll have no problem with this approach.
>>>
>>> I hope this helps,
>> Sorry, i'm not sure if I have completely understand your suggestion. Are
>> you telling me to apply this transform only to my input data, or to all
>> the operations that are applied in the function used in kernel?
> Imagine that your matrix coefficients are:
>
>   2.5,     1, 4.7
> 45.3, 0.765,  10
>     0,     0,   1
>
> and your input is:
>
> 3420.56, 5410.76, 1
>
> You start by converting the matrix coefficients:
>
> 2.5 * 65536.0 = 163840
> ....
>
> so the matrix becomes:
>
>   163840 65536 308019
> 2968781 50135 655360
>        0     0  65536
>
> This can be done in userspace and the coefficients can be sent to the
> kernel as fixed point numbers.
>
> You do the same (this time on the kernel) with your input, so it becomes:
>
> 224169820 354599567 65536
>
> Now you can do:
>
> q[0] = fixed_mul(p[0], a[0][0]) + fixed_mul(p[1], a[1][0]) +
> fixed_mul(p[2], a[2][0]);
> ....
>
> where "fixed_mul" is a function that does the multiplication as I
> explained earlier.
>
> To convert the result back to an integer, just shift down by 16.
>

