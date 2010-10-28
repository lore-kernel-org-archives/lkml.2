Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714Ab0J1VCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:02:21 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65140 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166Ab0J1VCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        b=Kib59zN0M9YBAYTaeaZetYEX2+5ZcQ5QnBftYmuVNN5TqDcnKPjHkIOE3EO1zf9asL
         mx3U63apxRr1IsKFO2oPrvMqY8PCH3Dqoql7rSAVyGq/XI9qlgtsYY1XV86LH0DhUTme
         iRBE1OitA5xGjz5KOtQxBW4a9E6b5XQib1DwY=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101028203706.GD28126@thunk.org>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
	<20101028175221.GA1578@arch.trippelsdorf.de>
	<20101028180118.GC6814@thunk.org>
	<20101028193211.GA28126@thunk.org>
	<AANLkTimHJe9bA-X+JWkspgjb4AZkkgbEFWQiwzO-gx-h@mail.gmail.com>
	<20101028200548.GC28126@thunk.org>
	<AANLkTimw9Vwzy4MXO1t7TnJfwTwYtWcfj0D=Zx8O72cY@mail.gmail.com>
	<20101028203706.GD28126@thunk.org>
Date: Thu, 28 Oct 2010 23:02:14 +0200
Message-ID: <AANLkTimFgcCVgBrW_oLzn0tUdGwJKfkhDJMf=EVHZ4Vf@mail.gmail.com>
Subject: Re: [next-20101038] Call trace in ext4
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Ted Ts'o" <tytso@mit.edu>, sedat.dilek@gmail.com,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>,
        Avinash Kurup <kurup.avinash@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 10:37 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Oct 28, 2010 at 10:15:00PM +0200, Sedat Dilek wrote:
>>
>> I created a new ext4.ko via "make M=fs/ext4" in the build-dir and
>> copied the the kernel-module to /lib/modules/$(uname
>> -r)/kernel/fs/ext4/, is that not enough?
>
> It might not be.  Some distributions include modules in the initial
> ramdisk, and load the module from the initrd, simply dropping the
> module in /lib/modules/<kver>/... might not be enough.  So recreating
> the initrd and then rebooting might be enough.
>
> Certainly if you drop it there on a running kernel, if you don't
> unload the module (before unmounting all of your ext4 file systems),
> and then reload the module, *definitely* just copying a module into
> /lib/modules.... without making sure the module is reloaded, you'll
> still have the old module.
>
>                                                - Ted
>

Grrr, did not think of ext4 kernel-module be in initrd.img.

OK, I have recreated a new one:

    $ update-initramfs -k 2.6.36-git11.sd.1-686 -c

I could copy a complete linux-2.6 GIT tree within my $HOME/src, looks good.

Any other test-case you can suggest to be sure things work as expected, now?

BTW, feel free to add:

      Reported-andtested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -
