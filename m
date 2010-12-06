Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab0LFPQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:16:39 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57702 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LFPQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:16:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KgIhMKMXjzc7rYEZ8T9DeXhv/tc7TsJS48TKFIR7D083hLfZn08ba56gMiU+Ztvr0B
         rqHNcJrh18o7mXwMOCwKh3r9eKYSGzalzg+AYkWkts7lDXvo7/bgIAyib6LUK1QBqoe7
         amxZrkkAwJteCTFjUiz6ZHOaLII6jF/+TBNCQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012060120590.16078@swampdragon.chaosbits.net>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
	<alpine.LNX.2.00.1012060120590.16078@swampdragon.chaosbits.net>
Date: Mon, 6 Dec 2010 17:16:36 +0200
Message-ID: <AANLkTinbq+NPHBQ=zqVNjUDL+G3fKdC6S9gYB5e4isNR@mail.gmail.com>
Subject: Re: [PATCH 01/45] kstrtox: converting strings to integers done
 (hopefully) right
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 2:25 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Sun, 5 Dec 2010, Alexey Dobriyan wrote:
>> Note: sizeof and __alignof__ trick is done to save function call
>>       where types aren't distinguishable.
>>
>> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>> ---
> <snip>
>> +/* Internal, do not use. */
>> +int _kstrtol(const char *s, unsigned int base, long *res)
>> +{
>> +     long long tmp;
>> +     int rv;
>> +
>> +     rv = kstrtoll(s, base, &tmp);
>> +     if (rv < 0)
>> +             return rv;
>> +     if (tmp != (long long)(long)tmp)
>> +             return -EINVAL;
>> +     *res = tmp;
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL(_kstrtol);
>
> Ok, probably I'm just being dense, but the "_" prefix tells me I probably
> shouldn't use this function. The comment clearly tells me I shouldn't use
> this function.
> So, why is this exported? And if it is not/should not be exported, then
> why is it not static?
> (goes for other functions in this patch as well).

It is used by kstrtol() if "long" and "long long" aren't the same type.
I can't ifdef it because gcc doesn't allow "#if sizeof(long long) == ".
"Do not use" hints "use kstrtol()".
