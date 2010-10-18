Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0JRJQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:16:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51077 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab0JRJQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:16:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kM91O7kTyGHBxWqok+TuO44gczA/tcZDx+XhWfFWa9jWAORXlwiTN2ZNklfD+0JBAa
         fYPM/BcegaCzRkJF79RN1nKQdoCsDWPgdO8oIL3j76CLwDmIWCcRxV6abYiQxbeNn0eZ
         MkIPAZ1fYXmA6Y5CbM6KNaWzagsjCYIbPMaE0=
MIME-Version: 1.0
In-Reply-To: <AANLkTik0dP0hs-a6ofna_UFk8dbzfqzPwD5OzDVhPGBV@mail.gmail.com>
References: <201010131328.06465.toralf.foerster@gmx.de>
	<201010171555.40453.toralf.foerster@gmx.de>
	<20101017201837.GA16458@lst.de>
	<201010181105.17077.toralf.foerster@gmx.de>
	<AANLkTik0dP0hs-a6ofna_UFk8dbzfqzPwD5OzDVhPGBV@mail.gmail.com>
Date: Mon, 18 Oct 2010 11:16:10 +0200
Message-ID: <AANLkTikDc+Gv=L-38cTUzZHWSib5tabvxAjR7GLAMU9c@mail.gmail.com>
Subject: Re: [uml-devel] Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        Christoph Hellwig <hch@lst.de>, Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/18 Geert Uytterhoeven <geert@linux-m68k.org>:
> 2010/10/18 Toralf Förster <toralf.foerster@gmx.de>:
>> Well, in addition to my last mail the following patch isn't a fix, but it
>> might point to the culprit.
>> If I apply this patch against latest tree, then the crash doesn't occur :
>>
>> diff --git a/include/linux/statfs.h b/include/linux/statfs.h
>> index 0166d32..e336e70 100644
>> --- a/include/linux/statfs.h
>> +++ b/include/linux/statfs.h
>> @@ -15,8 +15,8 @@ struct kstatfs {
>>        __kernel_fsid_t f_fsid;
>>        long f_namelen;
>>        long f_frsize;
>> -   long f_flags;
>>        long f_spare[4];
>> + long f_flags;
>>  };
>
> So it probably is accessing f_spare[4] somewhere...

fs/hostfs/hostfs_user.c does so.
I'll look at this when I'm at home.

Toralf, are you using hostfs?

> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Thanks,
//richard
