Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1KYRqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:46:51 -0500
Received: from mx01.edigma.com ([195.22.21.235]:51281 "EHLO mx01.edigma.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab1KYRqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:46:50 -0500
Message-ID: <4ECFD488.4060805@edigma.com>
Date: Fri, 25 Nov 2011 17:46:48 +0000
From: Nuno Santos <nsantos@edigma.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Floating point usage inside kernel
References: <S1754322Ab1KYK6W/20111125105822Z+929@vger.kernel.org> <4ECF789F.3040001@edigma.com> <4ECF8528.9080800@gmail.com> <4ECFBF56.4000002@edigma.com> <4ECFCAD5.5040606@grupopie.com>
In-Reply-To: <4ECFCAD5.5040606@grupopie.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Given the range of numbers you're working with, you can probably get
> away with just a 16.16 fixed point representation. The operations go
> like this:
>
> convert a double to a fixed point number just do (but not on the kernel):
>
>    fixed = (s32)(double * 65536.0);
>
> convert an integer to fixed:
>
>    fixed = integer<<  16;
>
> multiplication:
>
>    result = (s32)(((s64) fixed_a * fixed_b)>>  16);
>
> addition:
>
>    result = fixed_a + fixed_b;
>
> etc...
>
> Unless you have overflow or need more than 16 bits of fractional
> precision, you'll have no problem with this approach.
>
> I hope this helps,
Sorry, i'm not sure if I have completely understand your suggestion. Are 
you telling me to apply this transform only to my input data, or to all 
the operations that are applied in the function used in kernel?

Thanks,

With my best regards,

Nuno
