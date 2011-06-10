Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1FJDqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:46:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56306 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1FJDqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qj5Jm569sgO84O34oHYKrglQWmziEMxtrwWp8aNCc4fArNsfTCJ0255R52foflqUti
         T9+jrcSkUJiL7LEuzLLnkEZlwOxUhKlUf7Ch+k9lpxk3E69NWe7cQvHLLzaqAp6n3Kwy
         CkHAI0EZleSWkcLds8cteJOG/48b3B+F+rhNY=
MIME-Version: 1.0
In-Reply-To: <BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
References: <20110609214241.GA4849@sepie.suse.cz>
	<BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
	<BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com>
	<BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
Date: Thu, 9 Jun 2011 23:45:59 -0400
Message-ID: <BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes for 3.0
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 9, 2011 at 11:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jun 9, 2011 at 8:14 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>
>> any chance to share your .config ? x86-64's defconfig, plus Michal
>> branch merged on top of the tip of your tree, plus the following patch
>> removing the SUBLEVEL:
>>
>> diff --git a/Makefile b/Makefile
>> index 72c0e32..5c75864 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1,6 +1,6 @@
>>  VERSION = 3
>>  PATCHLEVEL = 0
>> -SUBLEVEL = 0
>> +SUBLEVEL =
>>  EXTRAVERSION = -rc2
>>  NAME = Sneaky Weasel
>>
>> install is fine for me. What bugs me is that "git grep '\.temp'" in
>> that tree does not return anything relevant.
>
> "make install" just runs the distro install script, usually
> /sbin/installkernel, which at least on F-14 will then run
> /sbin/new-kernel-pkg /sbin/dracut to build the initrd etc.
>
> And that runs "depmod", which seems to end up being confused: we give
> it the new kernel version as an argument, but it seems to not like it,
> so it decides to do "uname()" to get the _current_ kernel version
> instead, and that is where the confusion comes from.
>
For the record, this should have been fixed by Michal in:

commit 3328d178247017affd90b7897393699f2f45227d
Author: Michal Marek <mmarek@suse.cz>
Date:   Mon May 30 15:58:43 2011 +0200

    depmod: Handle X.Y kernel versions

    What a stupid check.

    Signed-off-by: Michal Marek <mmarek@suse.cz>
    Signed-off-by: Jon Masters <jcm@jonmasters.org>

from the module-init-tools git tree. Change is pretty trivial:

diff --git a/depmod.c b/depmod.c
index abfb11e..98a5efa 100644
--- a/depmod.c
+++ b/depmod.c
@@ -247,7 +247,7 @@ static int is_version_number(const char *version)
 {
        unsigned int dummy;

-       return (sscanf(version, "%u.%u.%u", &dummy, &dummy, &dummy) == 3);
+       return (sscanf(version, "%u.%u", &dummy, &dummy) == 2);
 }

 - Arnaud

> If it works for you, I suspect you're running a different distribution.
>
>                  Linus
>
