Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab0JRJJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:09:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49425 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab0JRJJw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n4BxPUA/ynw3jpABswy63lM/LuX+h9e8y4fZ+ZzJqF1/opmuaMjSPTi2zku+M5/xmJ
         mNV+lAHt1e+iB7+s1TlZJWyTA8nGGxYApZQqLUqX6YlFhz+01DoSdeBOscoWeoBk+17J
         5m+v91+i78Wfv4YGxDbXOoqznqkVgMkYdHHR4=
MIME-Version: 1.0
In-Reply-To: <201010181105.17077.toralf.foerster@gmx.de>
References: <201010131328.06465.toralf.foerster@gmx.de>
	<201010171555.40453.toralf.foerster@gmx.de>
	<20101017201837.GA16458@lst.de>
	<201010181105.17077.toralf.foerster@gmx.de>
Date: Mon, 18 Oct 2010 11:09:50 +0200
X-Google-Sender-Auth: yvzIW9IcUUIyif4kSn-LfWBQdug
Message-ID: <AANLkTik0dP0hs-a6ofna_UFk8dbzfqzPwD5OzDVhPGBV@mail.gmail.com>
Subject: Re: [uml-devel] Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/18 Toralf Förster <toralf.foerster@gmx.de>:
> Well, in addition to my last mail the following patch isn't a fix, but it
> might point to the culprit.
> If I apply this patch against latest tree, then the crash doesn't occur :
>
> diff --git a/include/linux/statfs.h b/include/linux/statfs.h
> index 0166d32..e336e70 100644
> --- a/include/linux/statfs.h
> +++ b/include/linux/statfs.h
> @@ -15,8 +15,8 @@ struct kstatfs {
>        __kernel_fsid_t f_fsid;
>        long f_namelen;
>        long f_frsize;
> -   long f_flags;
>        long f_spare[4];
> + long f_flags;
>  };

So it probably is accessing f_spare[4] somewhere...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
