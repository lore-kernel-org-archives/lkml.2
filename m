Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1HBVkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:40:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33103 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1HBVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:40:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110802120008.3e19d193@tlielax.poochiereds.net>
References: <CAPwCz79UntBiAs4X+XSj62xvkpK0CW6cqQqhyCU97r4u5SmJ_g@mail.gmail.com>
	<20110802064455.0777c0fd@corrin.poochiereds.net>
	<20110802120008.3e19d193@tlielax.poochiereds.net>
Date: Tue, 2 Aug 2011 23:40:04 +0200
Message-ID: <CAPwCz78UiObndz2j2YW6eu1ebNhqY+8bm-cfWGX-nkD9c13_Tg@mail.gmail.com>
Subject: Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for large dirs
From: Jan Seiffert <kaffeemonster@googlemail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sfrench@us.ibm.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/2 Jeff Layton <jlayton@redhat.com>:
> On Tue, 2 Aug 2011 06:44:55 -0400
> Jeff Layton <jlayton@redhat.com> wrote:
>
>> On Tue, 2 Aug 2011 02:30:35 +0200
>> Jan Seiffert <kaffeemonster@googlemail.com> wrote:
>>
[snip - bug report]
>>
>> Thanks for the bug report.

Hi Jeff,
thanks for your fast feedback, and sorry it took me so long to get back to you.

>> According to the spec, I think I was a
>> *little* off in the calculation but not by much. CIFSMaxBufSize doesn't
>> include the size of the header, so the value we're sending is too small
>> by 0x58 bytes. But, if anything though that should have led to the
>> server sending smaller frames than we can handle, which should not
>> cause this sort of problem.
>>
>> I tried to reproduce this on my test setup, but couldn't...
>>
>> Some questions...
>>
>> 1) did anything pop up in dmesg when this error occurred?
>>

No, nothing in dmesg.
Looks like it is detected as malformed packet and silently dropped.
(at dmesg default log level and default debug options)

>> 2) are you setting the CIFSMaxBufSize module parm to anything?
>>

No parameters to the CIFS module (i didn't even know till now there
are options...)

>> 3) would it be possible to get debugging output? Instructions on how to
>> do that are here:
>>
>> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging
>>

I will skip this ...

>> Thanks,
>
> Nevermind... I was able to reproduce it, and the following patch seems
> to fix it for me. Jan, can you test this as well?

.. to test your patch, and it looks good!

$ ls -l /usr/portage/ | wc -l
170
$ ls -l /usr/portage/distfiles/ | wc -l
47470

So here it is:
Tested-by: Jan Seiffert <kaffeemonster@googlemail.com>

> If so, I'll "officially" send it to Steve and we'll get this in ASAP.
>

I hope so ;)

> Long term, it would be better clean up the way CIFSMaxBufSize is
> handled to get rid of this source of confusion...
>

Sounds good, but with a lot of different servers (orig. Windows
versions and different Samba versions), i hope there is no maze of
endless special cases because all those versions did something subtle
different with the MaxBufSize (eg. simple +/-1 Bugs).

Greetings
Jan

[snip - patch]

-- 
Murphy's Law of Combat
Rule #3: "Never forget that your weapon was manufactured by the
lowest bidder"
