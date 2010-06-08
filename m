Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab0FHBeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 21:34:04 -0400
Received: from schemailmta02.cingularme.com ([209.183.37.52]:34091 "EHLO
	schemailmta02.cingularme.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517Ab0FHBeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 21:34:00 -0400
X-Greylist: delayed 1252 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jun 2010 21:34:00 EDT
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com> <4C0D5DCD.5010201@sandeen.net> <AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com> <AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com>
Message-Id: <889B6B31-A1F0-438D-B782-DBB855912854@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
In-Reply-To: <AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (iPhone Mail 7E18)
Subject: Re: EXT3 File System Corruption 2.6.34
Date: Mon, 7 Jun 2010 20:10:03 -0500
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (7E18)
X-Cloudmark-Analysis: v=1.0 c=1 a=dfBv_Z8tO0EA:10 a=ADBQPqJMlbwA:10 a=kj9zAlcOel0A:10 a=pGLkceISAAAA:8 a=5xOlfOR4AAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=NuBdGB7qgkvc_AcCiVkA:9 a=DGSd3cnoZWRRKchixgcA:7 a=SOZi6Zetk1L_S1vDhzd3V0lKk7gA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=MSl-tDqOz04A:10 a=ib5chTNvd7AA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 7, 2010, at 6:55 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:

> ---------- Forwarded message ----------
> From: Jeffrey Merkey <jeffmerkey@gmail.com>
> Date: Mon, Jun 7, 2010 at 5:54 PM
> Subject: Re: EXT3 File System Corruption 2.6.34
> To: Eric Sandeen <sandeen@sandeen.net>
>
>
> REPLY TO ALL
>
> CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
>
> Whether set this way or not, should not see corruption.

Here you are mistaken.  Mount with data=ordered and see.  Writeback  
can expose stale data.

-Eric

> I am seeing
> data corruption including the following:
>
> /boot/grub/grub.conf getting filled with binary chars
> /root/.viminfo filled with strange text chars (not binary)
> .o files filled with the same garbage.
>
> Looks like EXT3 meta data -- maybe some blocks getting transposed  
> somewhere?
>
> I will recreate the data patterns I see during corruption and post
> here.  They are consitent with some sort of fill pattern -- at least
> what I see in
> viminfo is.
>
> In the case of corrupted .o files, the endian headers are missing and
> trashed in the OBJ section headers -- chances are the same kind of
> garbage.
>
> Jeff
>
>
>>> Still seeing file system corruption after journal recovery in EXT3.
>>> It's easy to reproduce, though the symptoms vary.  One way is to
>>> rebuild a program and while the program is being compiled just shut
>>> off power to the system by pulling the plug.  I am seeing the
>>> /root/.viminfo file trashed after recovery if Vim was active during
>>> poweroff.  I am also seeing object modules getting built which the  
>>> LD
>>> linker claims are "invalid" following a recovery event.  I suspect a
>>> bug in the buffer cache since deleting the file still causes the old
>>> data to be returned from buffer cache even when the sectors are
>>> overwritten, but both are interrelated.  Seems in some way related  
>>> to
>>> EXT3 recovery which results in the buffer cache returning old  
>>> sectors
>>> and junk.
>>>
>>> Not hard to reproduce, but the symptoms are always a little  
>>> different
>>> but the /root/.viminfo file getting nuked seems a common affect of
>>> this bug.
>>
>> "file system corruption" usually means corrupted metadata, but I  
>> guess
>> here you mean file corruption, i.e. corrupted data.
>>
>> If you have buffered data in the cache, it will be lost when you pull
>> the plug.  If your userspace doesn't sync it, this is expected.   
>> But it's
>> not clear to me what you're seeing.
>>
>> I'm also not clear on what you mean about deleting the file and  
>> having old
>> data returned.  Maybe a little cut and paste from the screen would  
>> help
>> explain what you see.
>>
>> I'd also check CONFIG_EXT3_DEFAULTS_TO_ORDERED and be sure you're
>> using data=ordered mode by default.
>>
>> -Eric
>>
>>> Jeff
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
