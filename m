Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0JRIsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:48:25 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48234 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab0JRIsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OaLe+QOHOJKdceJD/zzKyp8CHcbbDq7ciXoeEWJeLTyQhne2ua3/q69IIfxABVecFP
         iRfMlpxf3XO4BBlJ5zo561H2YkJm+XjotYFEjqUptJhpkFK+y6BenFBHz2gA4QeVee2l
         MH/rRm/1D1tjxk5e552oy8owNuflGTt9jyp1Y=
MIME-Version: 1.0
In-Reply-To: <201010181043.14253.toralf.foerster@gmx.de>
References: <201010131328.06465.toralf.foerster@gmx.de>
	<201010171555.40453.toralf.foerster@gmx.de>
	<20101017201837.GA16458@lst.de>
	<201010181043.14253.toralf.foerster@gmx.de>
Date: Mon, 18 Oct 2010 10:48:23 +0200
Message-ID: <AANLkTimQQyYJorR81pt7Y7L8ru7OfPfzBtrT7FeA6m6W@mail.gmail.com>
Subject: Re: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/18 Toralf Förster <toralf.foerster@gmx.de>:
>
> Christoph Hellwig wrote at 22:18:37
>> I really can't see any relation to the patch.  Can you try the some
>> things in the following order, please:
> ...
>>  (4) re-apply the include/linux/statfs.h changes and see if it still
>>       boots
>
> The first half of step 4 was it (I did not apply the "Definitions for the flag
> in f_flag.") :
>
> diff --git a/include/linux/statfs.h b/include/linux/statfs.h
> index b34cc82..0166d32 100644
> --- a/include/linux/statfs.h
> +++ b/include/linux/statfs.h
> @@ -2,7 +2,6 @@
>  #define _LINUX_STATFS_H
>
>  #include <linux/types.h>
> -
>  #include <asm/statfs.h>
>
>  struct kstatfs {
> @@ -16,7 +15,29 @@ struct kstatfs {
>        __kernel_fsid_t f_fsid;
>        long f_namelen;
>        long f_frsize;
> -   long f_spare[5];
> + long f_flags;
> + long f_spare[4];
>  };
>
>
>
> FWIW the uml kernel boots fine even with that commit however it crashed after
> a special http request : $> wget http://n22_uml/phpsysinfo/

Find out _what_ phpsysinfo does.
On my test bed phpsysinfo works fine, I cannot reproduce the crash.
We need more details.

> --
> MfG/Kind regards
> Toralf Förster
>
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Thanks,
//richard
