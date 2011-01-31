Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1AaUXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:23:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41355 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab1AaUXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:23:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=na+zrDYY9HVQzDvV+nZfayqI9Sc8lYvpAooCQKjQjXvXr+wAfPj8BWmN1oF1f9JuIW
         aEmJwc+e7hJNvsw/lSScLhETbg/om+Iv0DZBsQJlDfC5TrgvgaD7ifpvzya14kiuPhSR
         F/rWo1AoUuBtYPgzEP3Rou8bEqHCuDd6OPNfc=
MIME-Version: 1.0
In-Reply-To: <AANLkTimTQxDCJ004VOFCdo3rz01tHsj9R4Ce1OGb75sH@mail.gmail.com>
References: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
	<AANLkTimTQxDCJ004VOFCdo3rz01tHsj9R4Ce1OGb75sH@mail.gmail.com>
Date: Mon, 31 Jan 2011 15:23:33 -0500
Message-ID: <AANLkTimCHUmEJ7wFbSF80Fz3b-nyr_PGqbJ5iq4uNSGF@mail.gmail.com>
Subject: Re: typecheck code
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for all explanation. It really helped to understand.

Sri

On Mon, Jan 31, 2011 at 1:03 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> On Mon, Jan 31, 2011 at 9:03 AM, Sri Ram Vemulpali
> <sri.ram.gmu06@gmail.com> wrote:
>> Hi all,
>>
>> /*
>>  * Check at compile time that something is of a particular type.
>>  * Always evaluates to 1 so you may use it easily in comparisons.
>>  */
>>  #define typecheck(type,x) \
>>  ({      type __dummy; \
>>        typeof(x) __dummy2; \
>>        (void)(&__dummy == &__dummy2); \
>>        1; \
>>  })
>>
>> #define typecheck_fn(type,function) \
>> ({      typeof(type) __tmp = function; \
>>       (void)__tmp; \
>> })
>>
>> Can anyone help me, explain the above code typecheck. How does
>> (void)(&__dummy == &__dummy2) evaluates to 1
>
> Infact I think it will never return 1, since the addresses of __dummy1
> and __dummy2 have to be different (off by 4 or 8). As pointed out it
> is the next line that always returns 1. The purpose of this line is to
> throw away warnings like "Incompatible pointer comparison" or
> something like that (haven't tried :-)) incase there is a mismatch.
>
> --
> Thanks -
> Manish
>



-- 
Regards,
Sri.
