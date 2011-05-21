Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab1EUFPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 01:15:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38548 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1EUFPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 01:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=x1Dl1WmwQVHD9oOVDZsqZoITDqq1Cy8pIoCVoviu605nif56OKFLMIw9Ki2iZIuHb/
         efbbBVyUWg3ELZpQNeDKAZnI63tVyOf2f4brx/6yMzVhEAnr0OXP2kfZiU+QvoCQwdZt
         hlcIn40t2r6O+Qlnkiwcnjd0Uwyqld3T7f6lg=
MIME-Version: 1.0
In-Reply-To: <20110519224445.GA9885@suse.de>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com> <20110519224445.GA9885@suse.de>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 20 May 2011 23:15:04 -0600
Message-ID: <BANLkTik6QHxzXoC-xAgkfw3-O_fzorLGww@mail.gmail.com>
Subject: Re: [PATCH 00/23] add register_chrdev_ids() to char_dev.c, API
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 4:44 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, May 19, 2011 at 03:33:03PM -0600, Jim Cromie wrote:
>> over on kernelnewbies, gregkh said:
>>
>>      The chardev stuff is a mess, I keep meaning for years to clean it
>>      up.  Any proposals on a sane interface for this stuff is greatly
>>      appreciated.
>>
>> this is a 1st step.
>>
>> register_chrdev_ids() replaces and deprecates register_chrdev_region()
>> and alloc_chrdev_region() with a single function that works for both
>> dynamic and static major numbers.
>>
>> Like alloc_chrdev_region(), 1st arg is a dev_t*, but its an in/out
>> parameter, and expects both major and minor to be preset, and thus the
>> separate minor arg is dropped.  If major == 0, a dynamic major is
>> reserved, saved into 1st arg, and thus available to caller afterwards.
>>
>> [PATCH 01/23] add register_chrdev_ids() to char_dev.c, API
>> [PATCH 02/23] reimplement alloc_chrdev_region with
>> [PATCH 03/23] use register_chrdev_ids to replace
>> [PATCH 04/23] use register_chrdev_ids in drivers/tty/
>> [PATCH 05/23] use register_chrdev_ids in drivers/infiniband/
>> [PATCH 06/23] use register_chrdev_ids in drivers/media/
>> [PATCH 07/23] use register_chrdev_ids in drivers/s390/
>> [PATCH 08/23] use register_chrdev_ids in drivers/scsi/
>> [PATCH 09/23] use register_chrdev_ids in drivers/staging/
>>
>> Ive held back the rest, no point in spamming.
>
> It's a nice first step, but that's the easy part, what is your 2nd
> through 4th one going to be?  :)
>
> I'd also like to sanatize the function namespace a bit as well, how
> about chrdev_register_ids() instead?

that seems sensible, modern.
also have register_chrdev(), which I presume should also be fixed.

> Ideally, we could drop down to a single register/unregister pair of
> functions, that are easy to use and understand.

__register_chrdev() does more stuff, mainly around cdevs, fops.
If fops was passed as NULL, we just do the __register_chardev_region()
and return early, skipping the cdev_alloc() and everything afterwards,
thus yielding register_chrdev_ids() behavior.

> Do you think you can
> get there with this intermediate step or do you want to step back and
> rethink this?

hmm.  If above is right, theres no need for the new api fn I added,
and probably should also drop the __ on both (un)?register_chardev.
So thats step 2 :)  Any ideas for 3 ?

btw, I think theres a major/minor error in the linuxdoc for the count
param in some of these register-* functions.  I'll take a closer look,
and send a patch RSN if needed, even if fn is going away later.


> thanks,
>
> greg k-h
>
