Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab1DARFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:05:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43762 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab1DARFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:05:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UW08aBrvl4yABWcGd5yhduvjrWILZZF3asLGP73BzZfVp/qypTiImvjf4/cM76zpG1
         UtEZbh2tSZ5kz70AUJOOXZi2ed+h2sPaCjSNBmqpsXsv+s5c6XlFof1mC4QLSg2YDsWh
         eCsj5sgkWi2SeSGdC48VyUzHcfn4IoncHCFyU=
Subject: Re: linux-next: Tree for April 1 [BROKEN ubifs when
 CONFIG_DEBUG_SECTION_MISMATCH=y]
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTin6dXV1bvgzwGuKKq_o08Wnz6Ddm38vFP4us4fC@mail.gmail.com>
References: <AANLkTi=td3J2duwv9RuXJHquA6=wRRq8vWLkJY97xtP9@mail.gmail.com>
	 <20110402030628.36a0b822.sfr@canb.auug.org.au>
	 <AANLkTin6dXV1bvgzwGuKKq_o08Wnz6Ddm38vFP4us4fC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 20:02:29 +0300
Message-ID: <1301677349.2789.120.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 18:10 +0200, Sedat Dilek wrote:
> On Fri, Apr 1, 2011 at 6:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Cc'ing Artem,
> >
> > On Fri, 1 Apr 2011 17:55:52 +0200 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> >>
> >> With CONFIG_DEBUG_SECTION_MISMATCH=y set, I see in my build.log:
> >> ...
> >> MODPOST 2742 modules
> >> ...
> >> ERROR: "empty_aops" [fs/ubifs/ubifs.ko] undefined!
> >> make[5]: *** [__modpost] Error 1
> >> make[4]: *** [modules] Error 2
> >> make[3]: *** [sub-make] Error 2
> >> make[2]: *** [all] Error 2
> >> make[2]: Leaving directory
> >> `/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/build_i386_none_686-iniza'
> >>
> >> - Sedat -
> >>
> >
> >
> > --
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > http://www.canb.auug.org.au/~sfr/
> >
> 
> Speculative patch (untested).
> 
> - Sedat -
> 
> $ diff -uprN fs/ubifs/xattr.c.orig fs/ubifs/xattr.c
> --- fs/ubifs/xattr.c.orig       2011-04-01 15:56:08.471082117 +0200
> +++ fs/ubifs/xattr.c    2011-04-01 18:08:27.355276827 +0200
> @@ -81,6 +81,7 @@ enum {
> 
>  static const struct inode_operations none_inode_operations;
>  static const struct file_operations none_file_operations;
> +static const struct address_space_operations empty_aops;
> 
>  /**
>   * create_xattr - create an extended attribute.

ubifs doess not have 'empty_aops' symbol and does not use such symbol. I
do not understand how you got that build issue, but this must be
something to do with your local setup.

Also:

[dedekind@eru linux-next (master)]$ grep -r 'empty_aops' *
fs/nilfs2/page.c:       static const struct address_space_operations empty_aops;
fs/nilfs2/page.c:       mapping->a_ops = &empty_aops;
fs/inode.c:     static const struct address_space_operations empty_aops;
fs/inode.c:     mapping->a_ops = &empty_aops;

in the current linux-next.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

