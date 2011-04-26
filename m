Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1DZXUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:20:17 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:52416 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752630Ab1DZXUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:20:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fNtDKc8R0YNYAgrI3z/KGyMLn6j1p3hPle/DxARacpxmPKvwToL20uga+vQviPvk5q8G/kXcZOHrhzhDwEOwvJHvK1FvbsD+Y2wSqYFwV9PBE6RBq0E/Sa81QkQ4M1Ex;
Date: Tue, 26 Apr 2011 16:20:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Cyril Brulebois <kibi@debian.org>, trivial@kernel.org
Subject: Re: [PATCH 3/4] Documentation/00-INDEX.sh: add script to help
 keeping the index up-to-date
Message-Id: <20110426162007.13929384.rdunlap@xenotime.net>
In-Reply-To: <20110424115811.e96c121f.rdunlap@xenotime.net>
References: <1303575344-10403-1-git-send-email-kibi@debian.org>
	<1303575344-10403-3-git-send-email-kibi@debian.org>
	<20110423093304.8a31e512.rdunlap@xenotime.net>
	<20110423210537.GI32680@debian.org>
	<20110424115811.e96c121f.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Apr 2011 11:58:11 -0700 Randy Dunlap wrote:

> On Sat, 23 Apr 2011 23:05:37 +0200 Cyril Brulebois wrote:
> 
> > Randy Dunlap <rdunlap@xenotime.net> (23/04/2011):
> > > The "undocumented" list looks correct (well, it could omit .orig
> > > files), but the "Documented but missing" list contains words, e.g.:
> > > […]
> > 
> > One coffee later… Looks like your grep is behaving as if "grep -F" was
> > passed; that might be better with an explicit "grep -G" (which is the
> > default), see patch below?
> 
> Sorry, this patch didn't help (did not change the output).
> 
> > diff --git a/Documentation/00-INDEX.sh b/Documentation/00-INDEX.sh
> > index 31d92d2..f22c260 100755
> > --- a/Documentation/00-INDEX.sh
> > +++ b/Documentation/00-INDEX.sh
> > @@ -4,7 +4,7 @@
> >  # Try and keep the 00-INDEX file up-to-date.
> >  
> >  # List all entries below the 00-INDEX entry:
> > -documented=$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -v '^\s'|sed 's,/$,,')
> > +documented=$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -G -v '^\s'|sed 's,/$,,')
> >  
> >  # List all files/directories except 00-INDEX* and Makefile:
> >  present=$(ls -1|grep -v '^00-INDEX'|grep -v '^Makefile$')
> > 
> > 
> > Maybe some grep alias in your environment? I couldn't reproduce the
> > behaviour you mentioned even using (unpack+PATH+LD_LIBRARY_PATH)
> > pcre-7.8-2.fc11.ppc.rpm and sed-4.2.1-1.fc11.ppc.rpm, until I tried
> > various options like passing -F to grep.
> 
> I couldn't find any grep alias, but I changed "grep" in 00-INDEX.sh to "/bin/grep"
> anyway, and still got the same results.

ad I don't see any environment variables that would affect grep either.

Anyway, using this line instead of any one of the lines above works for me:

documented=$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -G -v ^[[:space:]]|sed 's:/$::')

i.e., use ^[[:space:]] instead of the (original) '^\s'.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
