Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab0DFGVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 02:21:41 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50426 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab0DFGVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 02:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cmrSDiiygGn+/5M9py98u/ld6o1/Ciava1wn3BEfe4oyb/AihQRnUJqbJbMsFoQvaX
         nzsSxHpehJ6p+Wc1rsa1qtz1v3py+wzCOg7q87yW4N8NYitA8s+qR3jnLhJTyNE71cDq
         zEWt1WSP/sS++8F4QE9YKfFkS3K0UXCZ1T450=
Subject: Re: [PATCH] /dev/mem: Allow rewinding
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <y2h2375c9f91004052230i557aab00t7189369ba42f940d@mail.gmail.com>
References: <1270499041.9013.15.camel@edumazet-laptop>
	 <1270501448.9013.23.camel@edumazet-laptop>
	 <1270502345.9013.31.camel@edumazet-laptop>
	 <y2h2375c9f91004052230i557aab00t7189369ba42f940d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 08:21:27 +0200
Message-ID: <1270534887.9013.59.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 avril 2010 à 13:30 +0800, Américo Wang a écrit :
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index 1f3215a..3973a1d 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -710,11 +710,6 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
> >        switch (orig) {
> >        case SEEK_CUR:
> >                offset += file->f_pos;
> > -               if ((unsigned long long)offset <
> > -                   (unsigned long long)file->f_pos) {
> > -                       ret = -EOVERFLOW;
> > -                       break;
> > -               }
> 
> Why completely dropping the overflow check? What you need to do is just
> adding the 'offset < 0' case check.
> 

Because the overflow check at this point is completely redundant, it is
performed a few lines after...


