Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab0EYXw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:52:56 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58418 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0EYXwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JQ/D3YJr2eP0hl6xDKsOO5YVU/hqyvl/MfA3vBbegfvQp9rfwDq6saPKwAK2d6zCrK
         usQRQiKGmh6xT8okCAOvb6tUFfK9Js/YcXsIDvWNigm0JIgGWDArjf1wriOw+ZBo31g+
         DX1ELZito6Ajv5r0FomM7MgjDuo8fFxeI7nC8=
MIME-Version: 1.0
In-Reply-To: <4BFA59F7.2020606@cesarb.net>
References: <4BF81D87.6010506@cesarb.net>
	<20100523140348.GA10843@barrios-desktop>
	<4BF974D5.30207@cesarb.net>
	<AANLkTil1kwOHAcBpsZ_MdtjLmCAFByvF4xvm8JJ7r7dH@mail.gmail.com>
	<4BF9CF00.2030704@cesarb.net>
	<AANLkTin_BV6nWlmX6aXTaHvzH-DnsFIVxP5hz4aZYlqH@mail.gmail.com>
	<4BFA59F7.2020606@cesarb.net>
Date: Wed, 26 May 2010 08:52:52 +0900
Message-ID: <AANLkTikMTwzXt7-vQf9AG2VhwFIGs1jX-1uFoYAKSco7@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: Swap checksum
From: Minchan Kim <minchan.kim@gmail.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Cesar.

On Mon, May 24, 2010 at 7:50 PM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> Em 23-05-2010 23:05, Minchan Kim escreveu:
>>
>> On Mon, May 24, 2010 at 9:57 AM, Cesar Eduardo Barros<cesarb@cesarb.net>
>>  wrote:
>>>
>>> The internal ECC of the disk will not save you - a quick Google search
>>> found
>>> an instance of someone with silent data corruption caused by a faulty
>>> *power
>>> supply*.[1]
>>>
>>> And if it is silent corruption, without the checksums you will not notice
>>> it
>>> - it will just be dismissed as "oh, Firefox just crashed again" or
>>> similar
>>> (the same as bit flips on RAM without ECC).
>>
>> When I read your comment, suddenly some thought occurred to me.
>> If we can't believe ECC of the disk, why do we separate error
>> detection logic between file system and swap disk?
>>
>> I mean it make sense that put crc detection into block layer?
>> It can make sure any block I/O.
>
> There are differences as to where the checksum will be stored.
>
> For the filesystem (and for the software suspend image), you have to store
> the checksums in the disk itself, and the correct place (and ordering
> requirements) depends on the filesystem. Also, most filesystems do not
> currently have on-disk checksums.
>
> For the swap, it is much simpler; the checksums can be stored in memory
> (since they do not matter after a reboot; the swap contents are simply
> discarded). This also gives better performance, since the checksums do not
> have to be separately written, and more flexibility, since the kernel can
> use whatever kind of checksum it wants and can store the checksum in
> whatever data structure it choses, without worrying about compatibility.
>
> And, in fact, there is a CRC code in the block layer; it is
> CONFIG_BLK_DEV_INTEGRITY. However, it is not a generic solution; it needs
> some extra prerequisites (like a disk low-level formatted with sectors with
>>512 bytes).

Thanks for good information.

You mean BLK_DEV_INTEGRITY has a dependency with block device driver?
If you want to support checksum into suspend, At last, should we put
the checksum on disk?

I mean could we extend BLK_DEV_INTEGRITY by more generic solution?
As you said, in case of swap, we don't need to put checksum on disk.

If swap case, let it put the one on memory. If non-swap case, let it
put checksum on disk,
I am not sure it's possible.

When we have a unreliable disk, your point is that let's solve it with
(btrfs + swap) which both supports checksum. And my point is that
let's solve it with (any file system + swap) which is put on block
layer which supports checksum.

I am not a expert of block layer. so whatever i says might be nonsense.
And any mm guys don't oppose this idea until now(except Nick).
Could we regard it as ack of others?

If others don't oppose the idea, I will be not against, either.

Thanks, Cesar.

-- 
Kind regards,
Minchan Kim
