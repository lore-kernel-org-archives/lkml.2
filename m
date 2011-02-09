Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1BIUin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:38:43 -0500
Received: from straum.hexapodia.org ([207.7.131.186]:54058 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab1BIUim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:38:42 -0500
Date: Wed, 9 Feb 2011 12:38:41 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_KERNEL_XZ obscure build failure if xz(1) not installed
Message-ID: <20110209203841.GQ11874@hexapodia.org>
References: <20110209195258.GN11874@hexapodia.org> <4D52F404.4000709@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D52F404.4000709@pavlinux.ru>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:07:32PM +0300, Pavel Vasilyev wrote:
> > The failure is obscured by trailing make output, and since a broken
> > bzImage is created, "make install" succeeds, and the first visible
[snip]
>  :)
> 
> Signed-off-by: Pavel Vasilyev <pavel@pavlinux.ru>
> ---
> diff --git a/scripts/xz_wrap.sh b/scripts/xz_wrap.sh
> index 17a5798..5ec9d36 100644
> --- a/scripts/xz_wrap.sh
> +++ b/scripts/xz_wrap.sh
> @@ -20,4 +20,4 @@ case $ARCH in
>         sparc)          BCJ=--sparc ;;
>  esac
> 
> -exec xz --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB
> +exec xz --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB || exit 1
> 

I get the same behavior with and without your patch, tested with both
bash and dash.  (FWIW, /bin/sh on my systems is a symlink to /bin/dash.)

% printf '#!/bin/bash\nexec /no/such/file\n' > foo.sh
% chmod +x foo.sh
% ./foo.sh; echo $?
./foo.sh: line 2: /no/such/file: No such file or directory
./foo.sh: line 2: exec: /no/such/file: cannot execute: No such file or directory
126
% printf '#!/bin/bash\nexec /no/such/file\n' > foo.sh
% ./foo.sh; echo $?
./foo.sh: line 2: /no/such/file: No such file or directory
./foo.sh: line 2: exec: /no/such/file: cannot execute: No such file or
directory
126

% printf '#!/bin/dash\nexec /no/such/file\n' > foo.sh
% ./foo.sh; echo $?
exec: 2: /no/such/file: not found
2
% printf '#!/bin/dash\nexec /no/such/file || exit 1\n' > foo.sh
% ./foo.sh; echo $?
exec: 2: /no/such/file: not found
2

-andy
