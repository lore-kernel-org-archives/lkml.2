Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab1DNOaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:30:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65513 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab1DNOaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=ZAOcaJM+7h9At5xrhOZeI+tY4Xi7iK1pL5XC1gTOPZv+xFIwI78I4TAmUqj/dCSmrE
         7DbbKPAuK0ILalKWW1GoKZon65fKJ1i7DAY+MUETCq6waUJjyebWdKmf5s9kz8P8yT5V
         jUL3G2vxQUIcnH1G22QMto+XK/xNUzO8tJEI8=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kstrtox: reuse functions from ctype.h
References: <b266439c1f03640c677f911cb82f4d0e131d2e7d.1302785632.git.mina86@mina86.com> <BANLkTikk3Zof1Go8xLBeq2qyxGo6AFuv1g@mail.gmail.com>
Date: Thu, 14 Apr 2011 16:30:17 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtxmkrzr3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <BANLkTikk3Zof1Go8xLBeq2qyxGo6AFuv1g@mail.gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 16:06:34 +0200, Alexey Dobriyan <adobriyan@gmail.com>  
wrote:

> On Thu, Apr 14, 2011 at 4:34 PM, Michal Nazarewicz <mina86@mina86.com>  
> wrote:
>> kstrto*() family of functions uses open coded test
>> for a hexadecimal digit and
>
> Yes, so?

So it's better to avoid open-coded code without a reason if there is
already function for what one tries to do.

>> own implementation of tolower() function.
>
> No!
> It's special cased for this very usage, because the rest of ASCII is
> of no concern.
> It doesn't claim tolower() semantics.

Either way, the question is do we care about this optimisation so much
as to use it and somehow duplicate code which already is in ctype.h.

I'm not saying we don't.  I'm asking whether we want to.

>> @@ -47,8 +42,8 @@ static int _kstrtoull(const char *s, unsigned int  
>> base, unsigned long long *res)
>>
>>                if ('0' <= *s && *s <= '9')
>>                        val = *s - '0';
>> -               else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
>> -                       val = _tolower(*s) - 'a' + 10;
>> +               else if (isxdigit(*s))
>
> [0-9] are isxdigit() as well, so the code sort of logically duplicate.

Yes, so? ;)

I think isxdigit(*s) looks nicer than “'a' <= _tolower(*s) &&
_tolower(*s) <= 'f'”.

>> +                       val = tolower(*s) - 'a' + 10;

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
