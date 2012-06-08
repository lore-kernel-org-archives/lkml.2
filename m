Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115Ab2FHLAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 07:00:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44420 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2FHLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 07:00:04 -0400
Message-ID: <4FD1DB30.80307@suse.cz>
Date: Fri, 08 Jun 2012 13:00:00 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120530 Thunderbird/13.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delete seven tty headers
References: <1339145808.25798.28.camel@x61.thuisdomein>
In-Reply-To: <1339145808.25798.28.camel@x61.thuisdomein>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 10:56 AM, Paul Bolle wrote:
> 0) Tested with "git grep" only (by grepping on the file names). I
> haven't grepped on the many things these headers provide (mostly named
> constants). Some of these looked rather generic. Most of these headers
> were relevant for builds I don't have the toolchains for at hand. And,
> finally, I couldn't think of a way the things these headers provide
> could still actually be used in the tree. 
> 
> But would you prefer further tests?

Nope, it's enough to know nobody in the kernel includes them.

> 1) cdk.h, comstats.h, istallion.h, and stallion.h are still referenced
> in Documentation/ioctl/ioctl-number.txt and
> Documentation/magic-number.txt. Should those references be deleted too?

Yes, please.

> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -84,7 +84,6 @@ header-y += capability.h
>  header-y += capi.h
>  header-y += cciss_defs.h
>  header-y += cciss_ioctl.h
> -header-y += cdk.h
>  header-y += cdrom.h
>  header-y += cgroupstats.h
>  header-y += chio.h
> @@ -93,7 +92,6 @@ header-y += cn_proc.h
>  header-y += coda.h
>  header-y += coda_psdev.h
>  header-y += coff.h
> -header-y += comstats.h
>  header-y += connector.h
>  header-y += const.h
>  header-y += cramfs_fs.h

NACK for these two files. I rather prefer going through the
deprecate-wait_years-delete path (removal of __KERNEL__ parts, if there
are any, is OK). I doubt there are any users at all, but we still should
gave them a chance to fix their builds (remove those #include's and
potentially used defined/structs) and not introduce a userspace build
breakage.

The rest is OK to be removed.

thanks,
-- 
js
suse labs


