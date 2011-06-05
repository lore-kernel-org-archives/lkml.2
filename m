Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1FEHf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 03:35:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40382 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab1FEHfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 03:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ugIxFeTOt8xW/c60cgg1zYK1f1bE+dyoCnkw2T2sh2OEbmcHt437x5FGTMz+vWBoCG
         Pnuu5iYPisYVej5OkXiuJ/K+tyqP+dftxIN6kIPXiqBOws9j41XsenV29Im2MYT+bqdP
         aB8805LjW4Cbnzx/nAbjKhl9YHDRHCSVt6bbE=
Subject: Re: [PATCH] atomic: generalize atomic_add_unless_return
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@osdl.org>
In-Reply-To: <BANLkTinEkfRH-xJRyrtajSLEkEwrau7yRA@mail.gmail.com>
References: <1306889876-5327-1-git-send-email-asharma@fb.com>
	 <BANLkTinEkfRH-xJRyrtajSLEkEwrau7yRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Jun 2011 09:35:15 +0200
Message-ID: <1307259315.20604.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 05 juin 2011 à 00:09 -0400, Mike Frysinger a écrit :
> On Tue, May 31, 2011 at 20:57, Arun Sharma wrote:

> > --- a/include/linux/atomic.h
> > +++ b/include/linux/atomic.h
> >  /**
> > + * atomic_add_unless - add unless the number is already a given value
> > + * @v: pointer of type atomic_t
> > + * @a: the amount to add to v...
> > + * @u: ...unless v is equal to u.
> > + *
> > + * Atomically adds @a to @v, so long as @v was not already @u.
> > + * Returns the old value of @v + @a.
> > + */
> > +static inline int atomic_add_unless_return(atomic_t *v, int a, int u)
> 
> the name of the func in the comment does not match the actual name of the func
> 
> also, the semantics here appear to deviate from the other atomic
> funcs.  the existing xxx_return funcs return the new result, not the
> old.
> -mike

Arun comment is wrong, this function does return the new value of the
atomic_t after our operation, not the old ;)



