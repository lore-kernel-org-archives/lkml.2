Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab0IISsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:48:53 -0400
Received: from mail.perches.com ([173.55.12.10]:1566 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab0IISsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:48:52 -0400
Subject: Re: [rfc patch] treewide: Convert "static const char <*> foo[] ="
 to "static const char <*> const foo[] ="
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
References: <1284056536.24986.182.camel@Joe-Laptop>
	 <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 11:48:47 -0700
Message-ID: <1284058127.24986.199.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 14:29 -0400, Mike Frysinger wrote:
> On Thu, Sep 9, 2010 at 14:22, Joe Perches wrote:
> > To move data to const sections, specify
> > that the pointed to strings are also const.
> did you find cases where this couldnt be done ?

Nope.

> this is going to keep
> creeping back in with new drivers unless we have something like
> checkpatch.pl catching it ...

These are added pretty slowly, but both of

	static char foo[] = "bar"
and
	static const char *foo[] = {"bar"}

could be warned by checkpatch

> where is the actual patch ?

On my computer.  300KB is pretty big to post.
I'll sent it to you separately.

The script was:

search='\bstatic\s+const\s+char\s*\*\s*(\w+)\s*\[\s*\]\s*=\s*'
replace='static const char \* const \1\[\] = '
grep -rPl --include=*.[ch] "$search" * | \
while read file ; do \
	echo $file ; \
	perl -p -i -e "s/$search/$replace/g" $file ;\
done

with some hand cleanups for those functions that
needed to be changed to use "const char * const"

