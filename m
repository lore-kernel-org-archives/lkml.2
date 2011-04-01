Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab1DASWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:22:45 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65176 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039Ab1DASWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=lcD72GHCM+19vBa4td2SCgLCaPjdb6bPjwoUUMji75N9G1b33ulmOv4+WDNS9QLddd
         Jqr1VWSPx0nSFNGhkZ9/ET04ZHb6oPBZEmd48fAsG69STJB8Xk6eHIGbGjPgh1OQOL9S
         FG5WalAj2Wi2ifhaB99pPS6LffEZPL6uErOUQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 1 Apr 2011 20:22:41 +0200
Message-ID: <AANLkTimhD_cu46Bhtt9v8MjKMVCnVMT6Es+Ys9RNPOp1@mail.gmail.com>
Subject: Re: linux-next: Tree for April 1 [BROKEN ubifs when CONFIG_DEBUG_SECTION_MISMATCH=y]s
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: dedekind1@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 7:02 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Fri, 2011-04-01 at 18:10 +0200, Sedat Dilek wrote:
>> On Fri, Apr 1, 2011 at 6:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Cc'ing Artem,
>> >
>> > On Fri, 1 Apr 2011 17:55:52 +0200 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> >>
>> >> With CONFIG_DEBUG_SECTION_MISMATCH=y set, I see in my build.log:
>> >> ...
>> >> MODPOST 2742 modules
>> >> ...
>> >> ERROR: "empty_aops" [fs/ubifs/ubifs.ko] undefined!
>> >> make[5]: *** [__modpost] Error 1
>> >> make[4]: *** [modules] Error 2
>> >> make[3]: *** [sub-make] Error 2
>> >> make[2]: *** [all] Error 2
>> >> make[2]: Leaving directory
>> >> `/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/build_i386_none_686-iniza'
>> >>
>> >> - Sedat -
>> >>
>> >
>> >
>> > --
>> > Cheers,
>> > Stephen Rothwell                    sfr@canb.auug.org.au
>> > http://www.canb.auug.org.au/~sfr/
>> >
>>
>> Speculative patch (untested).
>>
>> - Sedat -
>>
>> $ diff -uprN fs/ubifs/xattr.c.orig fs/ubifs/xattr.c
>> --- fs/ubifs/xattr.c.orig       2011-04-01 15:56:08.471082117 +0200
>> +++ fs/ubifs/xattr.c    2011-04-01 18:08:27.355276827 +0200
>> @@ -81,6 +81,7 @@ enum {
>>
>>  static const struct inode_operations none_inode_operations;
>>  static const struct file_operations none_file_operations;
>> +static const struct address_space_operations empty_aops;
>>
>>  /**
>>   * create_xattr - create an extended attribute.
>
> ubifs doess not have 'empty_aops' symbol and does not use such symbol. I
> do not understand how you got that build issue, but this must be
> something to do with your local setup.
>
> Also:
>
> [dedekind@eru linux-next (master)]$ grep -r 'empty_aops' *
> fs/nilfs2/page.c:       static const struct address_space_operations empty_aops;
> fs/nilfs2/page.c:       mapping->a_ops = &empty_aops;
> fs/inode.c:     static const struct address_space_operations empty_aops;
> fs/inode.c:     mapping->a_ops = &empty_aops;
>
> in the current linux-next.
>
> --
> Best Regards,
> Artem Bityutskiy (Артём Битюцкий)
>
>

You are right, I pulled linux-2.6-block.git#for-linus into linux-next.
Looks like linux-2.6-block-for-linus/0007-fs-export-empty_aops.patch
is causing this [1].

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=2c9214b7b72cf440024d8b91523eea25bbc76040
