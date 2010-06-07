Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab0FGXzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 19:55:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35817 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0FGXzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 19:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=tU/PGFHojBquNLa+Ih7iYKtUcT0/OgQj73HximWVZnRZ2/u6cODlm0TOiPajd8BJwQ
         5YCBBCkoZt9I8H/MSGuAc0AUz04PId9k3MUH821L0bZHI/oUI6z4XjElXx/FaZxcmR+l
         E2xHuZ9gWkIUHZt9ZCPDc58wQo1aErOtDcGKM=
MIME-Version: 1.0
In-Reply-To: <AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com>
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
	<4C0D5DCD.5010201@sandeen.net>
	<AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com>
Date: Mon, 7 Jun 2010 17:55:22 -0600
Message-ID: <AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com>
Subject: Fwd: EXT3 File System Corruption 2.6.34
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Jeffrey Merkey <jeffmerkey@gmail.com>
Date: Mon, Jun 7, 2010 at 5:54 PM
Subject: Re: EXT3 File System Corruption 2.6.34
To: Eric Sandeen <sandeen@sandeen.net>


REPLY TO ALL

CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set

Whether set this way or not, should not see corruption.  I am seeing
data corruption including the following:

/boot/grub/grub.conf getting filled with binary chars
/root/.viminfo filled with strange text chars (not binary)
.o files filled with the same garbage.

Looks like EXT3 meta data -- maybe some blocks getting transposed somewhere?

I will recreate the data patterns I see during corruption and post
here.  They are consitent with some sort of fill pattern -- at least
what I see in
viminfo is.

In the case of corrupted .o files, the endian headers are missing and
trashed in the OBJ section headers -- chances are the same kind of
garbage.

Jeff


>> Still seeing file system corruption after journal recovery in EXT3.
>> It's easy to reproduce, though the symptoms vary.  One way is to
>> rebuild a program and while the program is being compiled just shut
>> off power to the system by pulling the plug.  I am seeing the
>> /root/.viminfo file trashed after recovery if Vim was active during
>> poweroff.  I am also seeing object modules getting built which the LD
>> linker claims are "invalid" following a recovery event.  I suspect a
>> bug in the buffer cache since deleting the file still causes the old
>> data to be returned from buffer cache even when the sectors are
>> overwritten, but both are interrelated.  Seems in some way related to
>> EXT3 recovery which results in the buffer cache returning old sectors
>> and junk.
>>
>> Not hard to reproduce, but the symptoms are always a little different
>> but the /root/.viminfo file getting nuked seems a common affect of
>> this bug.
>
> "file system corruption" usually means corrupted metadata, but I guess
> here you mean file corruption, i.e. corrupted data.
>
> If you have buffered data in the cache, it will be lost when you pull
> the plug.  If your userspace doesn't sync it, this is expected.  But it's
> not clear to me what you're seeing.
>
> I'm also not clear on what you mean about deleting the file and having old
> data returned.  Maybe a little cut and paste from the screen would help
> explain what you see.
>
> I'd also check CONFIG_EXT3_DEFAULTS_TO_ORDERED and be sure you're
> using data=ordered mode by default.
>
> -Eric
>
>> Jeff
>
>
