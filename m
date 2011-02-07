Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1BGS4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:56:32 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50660 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1BGS4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:56:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DSoJWTexGfrM0AWoXvUu66eFmmQIxh3JOYNQcACjwbBqTXYd/HEhfHW2qmXPWsyLkm
         NF71hXsZIawDKfO+8AtQtfV3wgaGY5LAjmRouDDA/IBtZV7/2gh6MC9/8GHJee3v3XJs
         pvdRXkM0krBsA8QZWwe48uOCihvzdPmRgnai4=
MIME-Version: 1.0
In-Reply-To: <20110207174552.GC3457@thunk.org>
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
	<20110207174552.GC3457@thunk.org>
Date: Mon, 7 Feb 2011 18:56:28 +0000
Message-ID: <AANLkTinybnXVk9WRsvrLLfhWGXm1=jQnTGvE0JT6=RXs@mail.gmail.com>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
From: Matt <jackdachef@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 5:45 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Feb 04, 2011 at 10:40:47PM +0000, Matt wrote:
>>
>> So that means that the file-corruption which existed until 2.6.37-rc6
>> and got triggered (for me) more easily via "dm crypt: scale to
>> multiple CPUs"
>> is fixed now ?
>
> Well, a patch exists for it that will be merged into 2.6.38.
>
>> That should give ext4 a nice speedup for >=2.6.38 :)
>
> I'm not going to make it be the default for 2.6.38, since it's fairly
> late in the -rc features.  People who want it can explicitly enable it
> using the mount option mblk_io_submit, though.  (And let me know your
> success stories!  :-) I will be enabling it as the default in
> 2.6.39-rc1.
>

Hi Ted,

I guess it should be save to enable it with 2.6.37, dm-crypt multi-cpu
patch and the following patch ?

"ext4: Fix data corruption with multi-block writepages support"
(of course that's the minimum - it would be better to pull in the ext4
changes for 2.6.38)


For a short time I had it activated (via additional) mblk_io_submit
mount-command on my portage-partition (where the portage-ball of my
Gentoo system is).
I was curious to see what messages I would get and wondered why there
was nothing about mballoc mentioned

If I recall correctly there were always messages in the past, like:

EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled

these are from 2.6.28 -

I'm only getting:

EXT4-fs (dm-3): mounted filesystem with ordered data mode.

or

EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts:
commit=60,barrier=1

(I like to set the barriers / flushes explicitly).

Sorry if I didn't follow development but these messages were kind of
more and more silenced ?


Thanks !


>> Reported-by: Matthias Bayer <jackdachef <at> gmail <dot> com >
>
> Sure!

Thanks !


>
>                                                - Ted
>

Regards

Matt
