Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab1DWQdL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:33:11 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:47217 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755203Ab1DWQdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:33:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=P676//7KYBC+ktMKBPyrZfJx/Lz+LLr609WfT/VEPOYgeNJiyRtSJ4KRrImtltbLyNG0Zv7zNxQSrxkE5IA8E8SPX/hmlrbzTpmAC+wG7uwDyQdG1zob+3ahCuVZ2L1k;
Date: Sat, 23 Apr 2011 09:33:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Cyril Brulebois <kibi@debian.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 3/4] Documentation/00-INDEX.sh: add script to help
 keeping the index up-to-date
Message-Id: <20110423093304.8a31e512.rdunlap@xenotime.net>
In-Reply-To: <1303575344-10403-3-git-send-email-kibi@debian.org>
References: <1303575344-10403-1-git-send-email-kibi@debian.org>
	<1303575344-10403-3-git-send-email-kibi@debian.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 18:15:43 +0200 Cyril Brulebois wrote:

> Signed-off-by: Cyril Brulebois <kibi@debian.org>
> ---
>  Documentation/00-INDEX.sh |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
>  create mode 100755 Documentation/00-INDEX.sh
> 
> diff --git a/Documentation/00-INDEX.sh b/Documentation/00-INDEX.sh
> new file mode 100755
> index 0000000..31d92d2
> --- /dev/null
> +++ b/Documentation/00-INDEX.sh
> @@ -0,0 +1,24 @@
> +#!/bin/sh
> +# Copyright 2011 Cyril Brulebois <kibi@debian.org>
> +#
> +# Try and keep the 00-INDEX file up-to-date.
> +
> +# List all entries below the 00-INDEX entry:
> +documented=$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -v '^\s'|sed 's,/$,,')
> +
> +# List all files/directories except 00-INDEX* and Makefile:
> +present=$(ls -1|grep -v '^00-INDEX'|grep -v '^Makefile$')
> +
> +echo "Undocumented:"
> +for i in $present; do
> +  if ! echo "$documented"|grep -qs "\<$i\>"; then
> +    echo "  $i"
> +  fi
> +done
> +
> +echo "Documented but missing:"
> +for i in $documented; do
> +  if [ ! -e $i ]; then
> +    echo "  $i"
> +  fi
> +done
> -- 

Good idea, thanks.

but what am I doing wrong?

cd Documentation
sh ./00-INDEX.sh

The "undocumented" list looks correct (well, it could omit .orig files),
but the "Documented but missing" list contains words, e.g.:

  -
  this
  file.
  -
  info
  on
  kernel
  <->
  userspace
  and
  relative
  interface
  stability.
  -
  brute
  force
  method
  of
  doing
  binary
  search
  of
  patches

on and on and on ...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
