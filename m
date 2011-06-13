Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1FMLcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:32:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34132 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1FMLcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QVkMP6EC/LewcHhVY3pkhcUOAjT7s9GzW6BtqfjA1mA+XVggwjjzN/2VIWhEq93U6/
         UM8liF1uxbq5vBoTSNghMIiBPAjdJfw3JIjZTTnng3iQrLVZG4vYOjFsY/L7jc0xzxVg
         gUBofYG6KLJqI7xK1nPF0K2fzrDeNKVikUoKg=
MIME-Version: 1.0
In-Reply-To: <1307960558.1878.21.camel@epip-laptop>
References: <1307617752-23426-1-git-send-email-gxt@mprc.pku.edu.cn>
	<BANLkTikNC8uh-X_0iJZH3tYd_kf46W1Rwg@mail.gmail.com>
	<BANLkTimWYjzxhQBH2A76D590KBfjKbguTA@mail.gmail.com>
	<1307675815.1537.9.camel@epip-laptop>
	<BANLkTi=aVFisCuS-W-4iNSmDVCtKOWD5_w@mail.gmail.com>
	<1307955422.1878.3.camel@epip-laptop>
	<BANLkTim7znORJyhM2D9r7+p0CiYc+RL97Q@mail.gmail.com>
	<1307960558.1878.21.camel@epip-laptop>
Date: Mon, 13 Jun 2011 20:32:15 +0900
Message-ID: <BANLkTinA699+vMt6SKEGmiZGsWp7UUD42Q@mail.gmail.com>
Subject: Re: [PATCH] unicore32: fix build error for find bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: gxt@mprc.pku.edu.cn
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/13 Guan Xuetao <gxt@mprc.pku.edu.cn>:
> On Mon, 2011-06-13 at 18:33 +0900, Akinobu Mita wrote:
>> 2011/6/13 Guan Xuetao <gxt@mprc.pku.edu.cn>:
>> > Thanks, please review following patch:
>>
>> Looks good to me.
> Could I add your acked-by information on this patch?

Of course, yes.

>> > diff --git a/arch/unicore32/kernel/ksyms.c
>> > b/arch/unicore32/kernel/ksyms.c
>> > index a897080..d98bd81 100644
>> > --- a/arch/unicore32/kernel/ksyms.c
>> > +++ b/arch/unicore32/kernel/ksyms.c
>> > @@ -24,8 +24,8 @@
>> >
>> >  #include "ksyms.h"
>> >
>> > -EXPORT_SYMBOL(__uc32_find_next_zero_bit);
>> > -EXPORT_SYMBOL(__uc32_find_next_bit);
>> > +EXPORT_SYMBOL(find_next_zero_bit);
>> > +EXPORT_SYMBOL(find_next_bit);
>>
>> I'm wondering why there are no EXPORT_SYMBOL for find_first_bit
>> and find_first_zero_bit.
> IMO, only functions that are needed by modules should be exported.
> When building modules under unicore32 & pkunity-soc, we only need
> find_next_bit and find_next_zero_bit exported at present, and if new
> functions are required, I am going to add them in the same time.
> In fact, I think, the 'arch-generic' ksyms.c is a better idea.

OK, I see.
