Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0E1LhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:37:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52411 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab0E1LhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:37:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l7vKLNC7EoITMyUxiEfYW/uAQY/EUxl4yrInEhAzD8mSAfNKWK33E9qw/3qSxXrYEX
         3btg053FzfVFMeVpLAAMX66ZojuOJGQlAJf8xwA7pVMh+Tw6msuwPLpgAsdrGsUFVZ20
         BCQezAI7MmXsZUSKpx2jZmd6yrQwZXyczbjLc=
MIME-Version: 1.0
In-Reply-To: <E1OHxTV-0002u1-Vo@pomaz-ex.szeredi.hu>
References: <1274885083-15735-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHw5Q-00020q-Dk@pomaz-ex.szeredi.hu> <AANLkTill8Y1RNTzZ9BFmVHPxLyx7CZIL5okqUCRVrrmH@mail.gmail.com> 
	<E1OHwZC-0002KS-EJ@pomaz-ex.szeredi.hu> <AANLkTikJMLiaUIVohTPy4DLF4XmWsy7LCx0bDheq2aHM@mail.gmail.com> 
	<E1OHxTV-0002u1-Vo@pomaz-ex.szeredi.hu>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 28 May 2010 19:36:36 +0800
Message-ID: <AANLkTinBmZej_rQFQ_bMPJf9GGJFFW3zdnpqZTXZCIfc@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] splice: fix updating sd->pos wrongly
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: axboe@kernel.dk, viro@zeniv.linux.org.uk, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 7:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, 28 May 2010, Changli Gao wrote:
>>  Before checking the sd->pos, sd->pos
>> already is updated with the value returned by splice_read(), so if in
>> file is seekabble, sd->pos is non-zero when I checking it.
>
> I see the logic now.  But it's really confusing, at least some
> comments would be needed.
>
> But I think it would be better not to try reusing sd->pos for reading,
> but supplying an "loff_t *read_ppos" to splice_direct_to_actor and
> leaving sd->pos alone (for the write side to use and update as
> necessary).
>

               if (ret < read_len) {

I think is much like a hack too. :)

-                       sd->pos = prev_pos + ret;
+                       if (sd->pos)
+                               sd->pos = prev_pos + ret;
                       goto out_release;
               }

Anyway, it can fix the issue I mentioned above. Any future cleanup
should not be mixed in, IMO.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
