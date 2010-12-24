Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0LXOYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 09:24:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51969 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0LXOYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 09:24:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MlYphyqmTu52dicrUfGzpwHSwDWlkKglIHdNateQbASwFw9BY4RXetl5fgqomDKx8x
         GwhMp3pZP0kXnT2fOdACtgv/AcV2ZIcoojciCh4ri/5qIvSepVl5BNosvUIsQroZi51X
         lQ4wA7K39btI44W9HKtY2qykX7jNMsh5JOhNU=
MIME-Version: 1.0
In-Reply-To: <20101224035523.GC25057@suse.de>
References: <AANLkTi=vfO-rs_iStXkPC7STSqfgUEW_JKt2w1=Wmf6Z@mail.gmail.com>
	<20101224035523.GC25057@suse.de>
Date: Fri, 24 Dec 2010 22:24:02 +0800
Message-ID: <AANLkTi=PwGXTKKyXDA1sckosbGmeo+D0bGuXt3Jb-ttc@mail.gmail.com>
Subject: Re: [PATCH] fix freeing user_struct in user cache
From: Hillf Danton <dhillf@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 11:55 AM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Dec 23, 2010 at 08:52:34PM +0800, Hillf Danton wrote:
>> When racing on adding into user cache, the new allocated from mm slab
>> is freed without putting user namespace.
>>
>> Since the user namespace is already operated by getting, putting has
>> to be issued.
>>
>> btw, it could be freed out of lock?
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/kernel/user.c   2010-11-01 19:54:12.000000000 +0800
>> +++ b/kernel/user.c   2010-12-23 20:42:00.000000000 +0800
>> @@ -158,6 +158,7 @@ struct user_struct *alloc_uid(struct use
>>               spin_lock_irq(&uidhash_lock);
>>               up = uid_hash_find(uid, hashent);
>>               if (up) {
>> +                     put_user_ns(ns);
>>                       key_put(new->uid_keyring);
>>                       key_put(new->session_keyring);
>>                       kmem_cache_free(uid_cachep, new);
>
> Hm, are you sure about this?  Also, why send this to me, did I last
> touch this?
>

sure with no doubt.

I do not know if you touched that last, but I received the following message,

On Tue, Dec 21, 2010 at 3:42 AM,  <gregkh@suse.de> wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>    bonding: Fix slave selection bug.
>
> to the 2.6.36-stable tree which can be found at:
>    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

so you were Cced since you charge patch delivered.

Cheers

Hillf

> confused,
>
> greg k-h
>
