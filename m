Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab0EZX1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:27:52 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63738 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab0EZX1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n8g91mc0Ya+wvMfImT2Uo1jwxQRPYq/AGvLE70JPd6s0N/AbF7lN0GPNTLLMpckPvX
         3BYeGYmsXDsR4AL9va7jg5tJJWV4CQ5hFV0v6i7VfQl0JVZ92Q6NjVK0Y93QughnQOdV
         4Njfe1u/IBoZq1Z27ox8stZZFkS8Pb234s54k=
MIME-Version: 1.0
In-Reply-To: <4BFDAC75.5070906@cesarb.net>
References: <4BF81D87.6010506@cesarb.net>
	<20100523140348.GA10843@barrios-desktop>
	<4BF974D5.30207@cesarb.net>
	<AANLkTil1kwOHAcBpsZ_MdtjLmCAFByvF4xvm8JJ7r7dH@mail.gmail.com>
	<4BF9CF00.2030704@cesarb.net>
	<AANLkTin_BV6nWlmX6aXTaHvzH-DnsFIVxP5hz4aZYlqH@mail.gmail.com>
	<4BFA59F7.2020606@cesarb.net>
	<AANLkTikMTwzXt7-vQf9AG2VhwFIGs1jX-1uFoYAKSco7@mail.gmail.com>
	<4BFCF645.2050400@cesarb.net>
	<20100526153144.GA3650@barrios-desktop>
	<22942.1274909335@localhost>
	<AANLkTikwxCvxHI0-d1hGctEmfGRuDUlZ7wAbEXbrS1WA@mail.gmail.com>
	<4BFDAC75.5070906@cesarb.net>
Date: Thu, 27 May 2010 08:27:50 +0900
Message-ID: <AANLkTikQ5ROn-mbhdguMcitmL19WVFSwdD00W0tz0Z2W@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: Swap checksum
From: Minchan Kim <minchan.kim@gmail.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Valdis.Kletnieks@vt.edu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 8:19 AM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> Em 26-05-2010 19:45, Minchan Kim escreveu:
>>
>> On Thu, May 27, 2010 at 6:28 AM,<Valdis.Kletnieks@vt.edu>  wrote:
>>>
>>> On Thu, 27 May 2010 00:31:44 +0900, Minchan Kim said:
>>>>
>>>> On Wed, May 26, 2010 at 07:21:57AM -0300, Cesar Eduardo Barros wrote:
>>>>>
>>>>> far as I can see, does nothing against the disk simply failing to
>>>>> write and later returning stale data, since the stale checksum would
>>>>> match the stale data.
>>>>
>>>> Sorry. I can't understand your point.
>>>> Who makes stale data? If any layer makes data as stale, integrity is up
>>>> to
>>>> the layer. Maybe I am missing your point.
>>>> Could you explain more detail?
>>>
>>> I'm pretty sure that what Cesar meant was that the following could
>>> happen:
>>>
>>> 1) Write block 11983 on the disk, checksum 34FE9B72.
>>> (... time passes.. maybe weeks)
>>> 2) Attempt to write block 11983 on disk with checksum AE9F3581. The write
>>> fails
>>> due to a power failure or something.
>>> (... more time passes...)
>>> 3) Read block 11983, get back data with checksum 34FE9B72. Checksum
>>> matches,
>>> and there's no indication that the write in (2) ever failed. The program
>>> proceeds thinking it's just read back the most recently written data,
>>> when in
>>> fact it's just read an older version of that block. Problems can ensue if
>>> the
>>> data just read is now out of sync with *other* blocks of data - instant
>>> data
>>> corruption.
>>
>> Oh, doesn't normal disk support atomicity of sector write?
>> I have been thought disk must support atomicity of sector write at least.
>
> It is called a "high fly write" (a write where the disk head was flying too
> high and the data did not get written at all). There are other causes than
> high fly writes for this, of course, but the symptom is the same: whatever
> you were trying to write was not written at all, and the old contents are
> still there.

It means that disk return _success_ even though data isn't written at
all on disk?

>
> The write is still atomic: it either did happen completely or did not happen
> at all (in this case, it did not happen at all). You *can* have a partial
> write (with a well-timed power loss, for instance), but the disk's own ECC
> will detect this as a corrupted sector and return an error on read.

Yes. still disk support atomicity as I expect.
Thanks.

>
> --
> Cesar Eduardo Barros
> cesarb@cesarb.net
> cesar.barros@gmail.com
>



-- 
Kind regards,
Minchan Kim
