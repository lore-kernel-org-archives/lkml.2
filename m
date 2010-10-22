Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0JVJaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:30:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53593 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0JVJaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=GohiJ8VSS6QbYF1EWC9cA037ORHbWz4mQArZPYxn8pLjRb7+yfS6ygMroe1J4oLhgn
         WwtxlAoHVQ1CTgHkyUwnWJ53hEGFScDLSknBfLZvio4b1gaOYVutUv/nW7qNzP5GBvP7
         gLh3fTgVJIZ/6nk0OxjWuMdsS8+JFHR7e0hzc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201010221124.32842.arnd@arndb.de>
References: <AANLkTi=vUA-u20egbpH1Wu4ek-craz7aZUxWmobL8OhD@mail.gmail.com>
	<201010221124.32842.arnd@arndb.de>
Date: Fri, 22 Oct 2010 11:30:17 +0200
Message-ID: <AANLkTimn9u-m8eOA7dQH6kCNriebEnnbYZaP_=rnp1pv@mail.gmail.com>
Subject: Re: linux-next: next-20101022 broken with unset CONFIG_BKL
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au,
        Jan Harkes <jaharkes@cs.cmu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 11:24 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 22 October 2010 11:13:23 Sedat Dilek wrote:
>> Hi,
>>
>> I am trying to compile latest linux-next with unset CONFIG_BKL.
>> Yes, one patch is missing from [1] to be able to compile a BKL-free kernel.
>> (BTW, the patch needs a trivial fix, see v2 attached to this email.)
>>
>> With next-20101022 the build breaks (sorry for the output in German):
>>
>> [ build.log ]
>> ...
>>   LD [M]  fs/ceph/ceph.o
>>   LD      fs/coda/built-in.o
>>   CC [M]  fs/coda/psdev.o
>>   CC [M]  fs/cifs/misc.o
>> /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/coda/psdev.c:
>> In function ‘coda_psdev_write’:
>> /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/coda/psdev.c:140:
>> error: implicit declaration of function ‘lock_kernel’
>> /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/coda/psdev.c:142:
>> error: implicit declaration of function ‘unlock_kernel’
>>   CC      block/blk-settings.o
>> make[6]: *** [fs/coda/psdev.o] Fehler 1
>> make[5]: *** [fs/coda] Fehler 2
>> make[5]: *** Warte auf noch nicht beendete Prozesse...
>> ...
>>
>> Just FYI.
>>
>
> Ok, thanks for the report. There is a patch for coda to remove the BKL.
> We discussed it yesterday and I subsequently removed the switch that
> disables it on non-BKL configs.
>
> We then agreed to not have the patch included in my series, and Jan's
> tree is not part of linux-next.
>
> There are more of these in mainline once Linus pulls my tree, but that
> just means that we need to get all the other trees into -rc1 that
> remove the BKL from other subsystems, before applying the patch that
> lets you build with CONFIG_FILE_LOCKING=y and CONFIG_BKL=n.
>
> Right now, both allyesconfig (with BKL) and allnoconfig (without coda)
> work fine, we only get a few really obscure randconfigs breaking.
>
>        Arnd
>

Wow, you answer in realtime :-), Arnd.
Thanks for the explanations and I agree with you to wait for 27-rc1
and then to remove BKL.
Me just doing early-testing...

A pointer to the patch?
Thanks in advance.

- Sedat -
