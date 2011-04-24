Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1DXS6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 14:58:18 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:45587 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754782Ab1DXS6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 14:58:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=CW40JI9pdd8cLEQ+bWgvzNrHOcBj+WFiC4QDch/9N7Gz/zOulgnIMckDJXQGiNN8jhCm2/ZHsueCQXHyt9s4dELKh6hOrwSq6wkWjF6qNoIF5GA077BPQzWgYbiQbse9;
Date: Sun, 24 Apr 2011 11:58:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Cyril Brulebois <kibi@debian.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 3/4] Documentation/00-INDEX.sh: add script to help
 keeping the index up-to-date
Message-Id: <20110424115811.e96c121f.rdunlap@xenotime.net>
In-Reply-To: <20110423210537.GI32680@debian.org>
References: <1303575344-10403-1-git-send-email-kibi@debian.org>
	<1303575344-10403-3-git-send-email-kibi@debian.org>
	<20110423093304.8a31e512.rdunlap@xenotime.net>
	<20110423210537.GI32680@debian.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 23:05:37 +0200 Cyril Brulebois wrote:

> Randy Dunlap <rdunlap@xenotime.net> (23/04/2011):
> > The "undocumented" list looks correct (well, it could omit .orig
> > files), but the "Documented but missing" list contains words, e.g.:
> > […]
> 
> One coffee later… Looks like your grep is behaving as if "grep -F" was
> passed; that might be better with an explicit "grep -G" (which is the
> default), see patch below?

Sorry, this patch didn't help (did not change the output).

> diff --git a/Documentation/00-INDEX.sh b/Documentation/00-INDEX.sh
> index 31d92d2..f22c260 100755
> --- a/Documentation/00-INDEX.sh
> +++ b/Documentation/00-INDEX.sh
> @@ -4,7 +4,7 @@
>  # Try and keep the 00-INDEX file up-to-date.
>  
>  # List all entries below the 00-INDEX entry:
> -documented=$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -v '^\s'|sed 's,/$,,')
> +documented=$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -G -v '^\s'|sed 's,/$,,')
>  
>  # List all files/directories except 00-INDEX* and Makefile:
>  present=$(ls -1|grep -v '^00-INDEX'|grep -v '^Makefile$')
> 
> 
> Maybe some grep alias in your environment? I couldn't reproduce the
> behaviour you mentioned even using (unpack+PATH+LD_LIBRARY_PATH)
> pcre-7.8-2.fc11.ppc.rpm and sed-4.2.1-1.fc11.ppc.rpm, until I tried
> various options like passing -F to grep.

I couldn't find any grep alias, but I changed "grep" in 00-INDEX.sh to "/bin/grep"
anyway, and still got the same results.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
