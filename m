Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555Ab0J1UPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:15:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36790 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761529Ab0J1UPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        b=AZMFTBumV5KQ1MQW/ruFtXsebXQFeSww+RPF6/QTHSaCmOCGXEkfnh1cxugzfVEXXy
         p4HQbJpkRKM3P68dJcfzoQ1jHW89xa/kVEt8EYAn0ai8DDXHj/GVdC+QmMwfp5hVGERQ
         34pQsBB22l+lH+Pu8kNKALslMfTwS91r9pBFo=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101028200548.GC28126@thunk.org>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
	<20101028175221.GA1578@arch.trippelsdorf.de>
	<20101028180118.GC6814@thunk.org>
	<20101028193211.GA28126@thunk.org>
	<AANLkTimHJe9bA-X+JWkspgjb4AZkkgbEFWQiwzO-gx-h@mail.gmail.com>
	<20101028200548.GC28126@thunk.org>
Date: Thu, 28 Oct 2010 22:15:00 +0200
Message-ID: <AANLkTimw9Vwzy4MXO1t7TnJfwTwYtWcfj0D=Zx8O72cY@mail.gmail.com>
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

On Thu, Oct 28, 2010 at 10:05 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Oct 28, 2010 at 09:54:23PM +0200, Sedat Dilek wrote:
>>
>> Hm, unfortunately NO (see logs).
>>
>> I have compiled via M=fs/ext4 in an already compiled build-tree with
>> these 3 patches.
>
> Ok, stupid question.  You did make sure the new ext4 module was
> loaded, right?
>
>> [  100.884524] ------------[ cut here ]------------
>> [  100.884718] kernel BUG at /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/ext4/inode.c:2721!
>
> OK, so after the patch, line 2721: changed from page_buffers() to:
>
>    if (!page_has_buffers(page))
>
> page_has_buffers() expands to:
>
> #define page_has_buffers(page)  PagePrivate(page)
>
> which expands to test_bit() call to see if PG_private1 is set in
> page->flags.  There is no BUG_ON anywhere there as far as I can tell.
>
> Line 2721 in the older kernel was page_has_buffers() which does have a
> BUG_ON check.
>
>                                        - Ted
>

I created a new ext4.ko via "make M=fs/ext4" in the build-dir and
copied the the kernel-module to /lib/modules/$(uname
-r)/kernel/fs/ext4/, is that not enough?
If not, I have to recompile a new kernel.

- Sedat -
