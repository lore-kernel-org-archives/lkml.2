Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab0KPA3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 19:29:01 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50676 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab0KPA3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 19:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=rhKr7FuaBw5UckGwZ7jcRKgQ0V0zBk0A3uZN8BiCiMarWcSKKp5GHIs7B+5F+GJtO2
         QfZsmSfD6PQqLyv9JjFa92tAFrto+/oYAIx8haR8bAZSHbujvhFu9M3VROFas/W+wPkC
         OAnvFGNDOGWNRhp3kFvtlnEOSaJp3+22bdqG4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201011151254.10277.arnd@arndb.de>
References: <AANLkTimgynsWk2pKvxkq7NdX75YguizyOWnVWPq7eXtL@mail.gmail.com>
	<201011151254.10277.arnd@arndb.de>
Date: Tue, 16 Nov 2010 01:28:59 +0100
Message-ID: <AANLkTimxa-3SYmTeTYX0jtfGiyUxiTq1rhE4ofJ3=A46@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IFsyLjYuMzctcmMxLWdpdDExXSBub25lLUJLTC1jb25maWc6IHN0cmFkaXMuYzogZQ==?=
	=?UTF-8?B?cnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24g4oCYbG9ja19rZXJuZWzigJkv4oCY?=
	=?UTF-8?B?dW5sb2NrX2tlcm5lbOKAmQ==?=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 12:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 14 November 2010, Sedat Dilek wrote:
>> with 2.6.37-rc1-git11 my none-BKL-config breaks (-git9 and -git9457b24
>> were OK) in stradis staging-crap.
>> Think the breakage aroses from [1].
>>
>> $ cd ~/src/linux-2.6/linux-2.6.37-rc1/debian/build/source_i386_none
>>
>> $ grep "error:" ../../../../build_linux-2.6_git11.sd.1.log
>> /home/sd/src/linux-2.6/linux-2.6.37-rc1/debian/build/source_i386_none/drivers/staging/stradis/stradis.c:1891:
>> error: implicit declaration of function ‘lock_kernel’
>> /home/sd/src/linux-2.6/linux-2.6.37-rc1/debian/build/source_i386_none/drivers/staging/stradis/stradis.c:1897:
>> error: implicit declaration of function ‘unlock_kernel’
>
> The driver is on its way out. I'll do a patch to just mark it "depends
> on BKL" to make sure it doesn't get built when BKL is disabled.
>
> It would be relatively easy to fix the right way, if you are interested.
>
>        Arnd
>

Thanks for the patch "staging/stradis: mark as "depends on BKL""  in [1].

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/arnd/bkl.git;a=commit;h=31a5739171c7c737653a6b1d415d7f285d6239b3
