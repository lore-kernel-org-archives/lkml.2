Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab0GHU6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab0GHU6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:58:14 -0400
Date: Thu, 8 Jul 2010 17:57:54 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Thavidu Ranatunga <tharan@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au1.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] perf: Version String fix, for fallback if not from
	git
Message-ID: <20100708205754.GH25306@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278316815-6099-2-git-send-email-tharan@au1.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 05, 2010 at 06:00:15PM +1000, Thavidu Ranatunga escreveu:
> This gets rid of the default version fallback for Perf and changes it so that it
> returns the version of the kernel from it's Makefile (if sources were not from
> git, ie. if it was downloaded from a tarball)
> 
> Signed-off-by: Thavidu Ranatunga <tharan@au1.ibm.com>
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>

>  	VN=$(git describe --abbrev=4 HEAD 2>/dev/null) &&
>  	case "$VN" in
>  	*$LF*) (exit 1) ;;
> @@ -27,7 +23,12 @@ elif test -d ../../.git -o -f ../../.git &&
>  then
>  	VN=$(echo "$VN" | sed -e 's/-/./g');
>  else
> -	VN="$DEF_VER"
> +	eval `grep '^VERSION\s*=' ../../Makefile|tr -d ' '`
> +	eval `grep '^PATCHLEVEL\s*=' ../../Makefile|tr -d ' '`
> +	eval `grep '^SUBLEVEL\s*=' ../../Makefile|tr -d ' '`
> +	eval `grep '^EXTRAVERSION\s*=' ../../Makefile|tr -d ' '`
> +
> +	VN="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${EXTRAVERSION}"

This makes 'make perf-tarbz2-src-pkg':

[acme@emilia linux-2.6-tip]$ make perf-tarbz2-src-pkg
  TAR
[acme@emilia linux-2.6-tip]$ mv perf-2.6.35-rc4.tar.bz2 /tmp
[acme@emilia linux-2.6-tip]$ cd /tmp
[acme@emilia tmp]$ tar xf perf-2.6.35-rc4.tar.bz2
[acme@emilia tmp]$ cd perf-2.6.35-rc4/tools/perf
[acme@emilia perf]$ make
grep: ../../Makefile: No such file or directory
grep: ../../Makefile: No such file or directory

- Arnaldo
