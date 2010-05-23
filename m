Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0EWFaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 01:30:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:8206 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab0EWFaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 01:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Z/RKLybBM8f7I558QlGAm2F3aPuFOrjONrzCmJpnTq4aW1JplkI0Lss8l3An4zTNOh
         GJO5DM4sEkz6rm21rxEyLFMXnBGHmH0dM45jCcPQ2Sdz4Uc8/LFGoa+fCilro4Ftq4md
         lM+Q7itkA+jSTxQYzAyfbMPxuRhxi/UQwwHJg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org>
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org>
Date: Sun, 23 May 2010 07:30:01 +0200
X-Google-Sender-Auth: IMdhbpiLtX1tbCpDEqZCGIExotY
Message-ID: <AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
From: Michael Kerrisk <mtk.manpages@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I see that this patch has hit Linus's git, so some questions

On Wed, May 19, 2010 at 6:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 19 May 2010, Miklos Szeredi wrote:
>>
>> One issue I see is that it's possible to grow pipes indefinitely.
>> Should this be restricted to privileged users?
>
> Yes. But perhaps only if it grows past the default (or perhaps "default*2"
> or similar). That way a normal user could shrink the pipe buffers, and
> then grow them again if he wants to.
>
> Oh, and I think you need to also require that there be at least two
> buffers. Otherwise we can't guarantee POSIX behavior, I think.

Is there any documentation (e.g., a man-pages patch) for these changes?

The argument of the fcntl() operations is expressed in pages. I take
it that this means that the semantics of the argument will very
depending on the system page size? So for example, 2 on x86 will mean
8192 bytes, but will mean 32768 of ia64? That seems very weird. (And
what about architectures where the page size is switchable?) Such
changes in semantics should not be silent for the use, IMO.

I'm not so sure about Linus's assertion above about needing at least
two buffers (pages?) to guarantee POSIX behavior. Back in 2.16.10 and
earlier, the buffer size was a page (4096 bytes) on x86-32, and we had
POSIX-compliant behavior.

Cheers,

Michael


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
