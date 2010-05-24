Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0EXAJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:09:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40785 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0EXAJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WjI17TwmHu4fNSasCAS43/zWWucTOKi+3Vt47nZRmD67OZ5TqYblydFOtjjCVLf80f
         5xJIDAwFwGGN/yQnOUS+FhRGdrF2uWaE30n2lTRWM0kLER7eRTIDEOxFmsI6wMxxbWFu
         hyKqN1iRlbNYKpBwAYC4TO/INOp9pywhbPQyw=
MIME-Version: 1.0
In-Reply-To: <4BF974D5.30207@cesarb.net>
References: <4BF81D87.6010506@cesarb.net>
	<20100523140348.GA10843@barrios-desktop>
	<4BF974D5.30207@cesarb.net>
Date: Mon, 24 May 2010 09:09:31 +0900
Message-ID: <AANLkTil1kwOHAcBpsZ_MdtjLmCAFByvF4xvm8JJ7r7dH@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: Swap checksum
From: Minchan Kim <minchan.kim@gmail.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Cesar.
I am not sure Cesar is first name. :)

On Mon, May 24, 2010 at 3:32 AM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> Em 23-05-2010 11:03, Minchan Kim escreveu:
>>
>> On Sat, May 22, 2010 at 03:08:07PM -0300, Cesar Eduardo Barros wrote:
>>>
>>> Add support for checksumming the swap pages written to disk, using the
>>> same checksum as btrfs (crc32c). Since the contents of the swap do not
>>> matter after a shutdown, the checksum is kept in memory only.
>>>
>>> Note that this code does not checksum the software suspend image.
>>
>> We have been used swap pages without checksum.
>>
>> First of all, Could you explain why you need checksum on swap pages?
>> Do you see any problem which swap pages are broken?
>
> The same reason we need checksums in the filesystem.
>
> If you use btrfs as your root filesystem, you are protected by checksums
> from damage in the filesystem, but not in the swap partition (which is often
> in the same disk, and thus as vulnerable as the filesystem). It is better to
> get a checksum error when swapping in than having a silently corrupted page.

Do you mean "vulnerable" is other file system or block I/O operation
invades swap partition and breaks data of swap?

If it is, I think it's the problem of them. so we have to fix it
before merged into mainline. But I admit human being always take a
mistake so that we can miss it at review time. In such case, it would
be very hard bug when swap pages are broken. I haven't hear about such
problem until now but it might be useful if the problem happens.
(Maybe they can't notice that due to hard bug to find)

But I have a concern about breaking memory which includes crc by
dangling pointer. In this case, swap block is correct but it would
emit crc error.

Do you have an idea making sure memory includes crc is correct?

Before review code, let's discuss we really need this and it's useful.
-- 
Kind regards,
Minchan Kim
