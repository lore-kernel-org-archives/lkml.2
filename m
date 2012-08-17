Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2HQV0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:26:47 -0400
Received: from seven.medozas.de ([5.9.24.206]:55830 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab2HQV0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:26:40 -0400
Date: Fri, 17 Aug 2012 23:26:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Michal Marek <mmarek@suse.cz>
cc: Daniel Wisehart <daniel.wisehart@eladian.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/patch-kernel fix
In-Reply-To: <501117A4.60704@suse.cz>
Message-ID: <alpine.LNX.2.01.1208172322000.3927@frira.zrqbmnf.qr>
References: <9b2de540-7ff6-4853-8331-5b9f0d28051c@mail.eladian.com> <501117A4.60704@suse.cz>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2012-07-26 12:10, Michal Marek wrote:
>On 19.7.2012 23:49, Daniel Wisehart wrote:
>> diff --git a/scripts/patch-kernel b/scripts/patch-kernel
>> index d000ea3..a7672eb 100755
>> --- a/scripts/patch-kernel
>> +++ b/scripts/patch-kernel
>> @@ -226,7 +226,7 @@ fi
>>  
>>  # This all assumes a 2.6.x[.y] kernel tree.
>>  # Don't allow backwards/reverse patching.
>> -if [ $STOPSUBLEVEL -lt $SUBLEVEL ]; then
>> +if [ "$STOPSUBLEVEL"0 -lt "$SUBLEVEL"0 ]; then
>
>Hi Daniel,
>
>While this is correct, it is not obvious at first sight why you need to
>multiply the numbers by 10. Or at least it was not obvious to me :).

Word has it some really old shells nobody would use to compile Linux on
interpret "" not as an empty argument, but as a non-existing argument,
turning if [ "" != "" ] into essentially if [ != ].

Doing x10 avoids the uncertainity whether shells might attempt to
interpret it as octal or not.
So far the interpretation..

>Could you use the more common idiom 0$NUMBER? The shell interprets the
>numbers as decimal, so it's works fine.

Wonder what POSIX says about that.
