Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0KOMCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 07:02:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48617 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0KOMCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 07:02:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=tqTpeqK2nG5cRjIInZQqCA5kUamuMLn2N9u9nTvIZi+iTNYTNVJorcKukUuYacI3rR
         bjx2l/fStTbK26KBK1ofjsiE4YrBTfmgnJ9XVLrAIzE/vQEQ8qGirax3Zuc6knRT6SLT
         DIbm8hhgagwL42WpkKWPGYm4mQMhC+XegBCAA=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201011151254.10277.arnd@arndb.de>
References: <AANLkTimgynsWk2pKvxkq7NdX75YguizyOWnVWPq7eXtL@mail.gmail.com>
	<201011151254.10277.arnd@arndb.de>
Date: Mon, 15 Nov 2010 13:02:11 +0100
Message-ID: <AANLkTimwSBo9tJUqBHAOBwLWmybOXdAPSY8Wx8bU_C7o@mail.gmail.com>
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

I was enjoying the nice sunshine weather on Sunday :-)... here in
South-West Germany.

Thus I had not had big time to look into the code... as stradis moved
to staging area, it got built this time in a none-BKL-config.
I checked a previous kernel and its dot-config and there was no
stradis inside, so never built before.

As stradis is marked DEPRECATED and I am not using it (even dunno what
it is, sorry for my ignorance), it's not that important.

A "depends on BKL" would be nice for the none-BKL-config folks to not
fall into the "pitfall".
If you have a patch for stradis, I would add it to my patchset.

Thank you in advance for helping to fix the issue.

- Sedat -
