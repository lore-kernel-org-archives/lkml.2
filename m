Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548Ab0EZWqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:46:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56308 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934434Ab0EZWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=huT92K7a+Cm8KL8qJn8yVwo6l/gk3gfnBqN2bM7jZJp67lNzoOvuzu0zg10DzQi1C0
         h/r7yMaYp4P4wxVr3ndzcEAbtaxawjIfy6r299U0fgl0zUKjDQH+eAqEl4y6OyK7CtuB
         tKFngsLEQn9Q+ECzh9rEfN5iaT77M+9IwfrUQ=
MIME-Version: 1.0
In-Reply-To: <22942.1274909335@localhost>
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
Date: Thu, 27 May 2010 07:45:56 +0900
Message-ID: <AANLkTikwxCvxHI0-d1hGctEmfGRuDUlZ7wAbEXbrS1WA@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: Swap checksum
From: Minchan Kim <minchan.kim@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 6:28 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 27 May 2010 00:31:44 +0900, Minchan Kim said:
>> On Wed, May 26, 2010 at 07:21:57AM -0300, Cesar Eduardo Barros wrote:
>> > far as I can see, does nothing against the disk simply failing to
>> > write and later returning stale data, since the stale checksum would
>> > match the stale data.
>>
>> Sorry. I can't understand your point.
>> Who makes stale data? If any layer makes data as stale, integrity is up to
>> the layer. Maybe I am missing your point.
>> Could you explain more detail?
>
> I'm pretty sure that what Cesar meant was that the following could happen:
>
> 1) Write block 11983 on the disk, checksum 34FE9B72.
> (... time passes.. maybe weeks)
> 2) Attempt to write block 11983 on disk with checksum AE9F3581. The write fails
> due to a power failure or something.
> (... more time passes...)
> 3) Read block 11983, get back data with checksum 34FE9B72. Checksum matches,
> and there's no indication that the write in (2) ever failed. The program
> proceeds thinking it's just read back the most recently written data, when in
> fact it's just read an older version of that block. Problems can ensue if the
> data just read is now out of sync with *other* blocks of data - instant data
> corruption.

Oh, doesn't normal disk support atomicity of sector write?
I have been thought disk must support atomicity of sector write at least.

AFAIK, other device(ex, nand device by FTL) supports atomicity of sector write.

-- 
Kind regards,
Minchan Kim
