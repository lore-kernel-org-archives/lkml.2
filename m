Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab1EMNik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:38:40 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:42386 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab1EMNii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=au0tGK3suA6GbaLza2V2Ku/nb4zR9V7AGG6X+H7P2Ds8J1I6oTJXCqrVhfAN8puUax
         kzax88xS1odGR1MgZBUQdzRLNxNk1ItoBGiGq0XA7t4QRv6KrRUfT5gKpsh4fKijrDQi
         DS+JViR8PnKK2gBsPAJy9B6amGoIk0txD0yAg=
MIME-Version: 1.0
In-Reply-To: <BANLkTikMeyRTOB9q4PEAYWnZRZfk3wg=kQ@mail.gmail.com>
References: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com> <BANLkTikMeyRTOB9q4PEAYWnZRZfk3wg=kQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 13 May 2011 09:38:18 -0400
X-Google-Sender-Auth: -tgTD_W66QvVrbTuV8la9oj1zAs
Message-ID: <BANLkTi=dL+KyQ3Bm58_Uj4LP9WSpbzAfJA@mail.gmail.com>
Subject: Re: AAARGH bisection is hard (Re: [2.6.39 regression] X locks up hard
 right after logging in)
To: Christian Couder <christian.couder@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, git@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shuang He <shuang.he@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 4:20 AM, Christian Couder
<christian.couder@gmail.com> wrote:
> On Thu, May 12, 2011 at 7:15 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>
>> OK, this sucks.  In the course of bisecting this, I've hit two other
>> apparently unrelated bugs that prevent my from testing large numbers
>> of kernels.  Do I have two questions:
>>
>> 1. Anyone have any ideas from looking at the log?
>>
>> It looks like most of what's left is network code, so cc netdev.
>>
>> 2.  The !&$#@ bisection is skipping all over the place.  I've seen
>> 2.6.37 versions and all manner of -rc's out of order.  Linus, and
>> other people who like pontificating about git bisection: is there any
>> way to get the bisection to follow Linus' tree?  I think that if
>> bisect could be persuaded to consider only changes that are reached by
>> following only the *first* merge parent all the way from the bad
>> revision to the good revision, then the bisection would build versions
>> that were at least good enough for Linus to pull and might have fewer
>> bisection-killing bugs.
>>
>> (This isn't a new idea [1], and git rev-list --bisect --first-parent
>> isn't so bad except that it doesn't bisect.)
>
> Did you forget to put the reference [1] in your email? Was it this one
> you were thinking about:
>
> http://thread.gmane.org/gmane.comp.version-control.git/165433/

No, it was this:

http://stackoverflow.com/questions/5638211/how-do-you-get-git-bisect-to-ignore-merged-branches

--Andy

>
> ?
>
> Thanks,
> Christian.
>
