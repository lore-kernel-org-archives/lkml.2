Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab2GQTq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:46:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38960 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2GQTqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:46:25 -0400
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <20120717193951.GA15208@burratino>
References: <1342547874.5129.2.camel@henna.lan>
	<20120717193951.GA15208@burratino>
Date: Tue, 17 Jul 2012 22:46:23 +0300
X-Google-Sender-Auth: 9JNtI5RIAJiEFpp2laUv_-ZIcKo
Message-ID: <CAPZXPQc02=6FnTb_RmgfpW+A4=N_huZW1FUYdjJ=Nt0Y3pqZ+A@mail.gmail.com>
Subject: Re: [PATCH] scripts/package/builddeb: upgrade to current practices
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/17 Jonathan Nieder <jrnieder@gmail.com>:
> Hi,
>
> Martin-Éric Racine wrote:
>
>> Signed-off-by: Martin-Éric Racine <martin-eric.racine@iki.fi>
>
> Thanks.  This patch does many things at once instead of the usual
> practice of "one patch per logical change", but oh well.
>
> [...]
>> --- a/scripts/package/builddeb
>> +++ b/scripts/package/builddeb
>> @@ -79,9 +79,9 @@ fwdir="$objtree/debian/fwtmp"
>>  kernel_headers_dir="$objtree/debian/hdrtmp"
>>  libc_headers_dir="$objtree/debian/headertmp"
>>  packagename=linux-image-$version
>> -fwpackagename=linux-firmware-image
>>  kernel_headers_packagename=linux-headers-$version
>>  libc_headers_packagename=linux-libc-dev
>> +fwpackagename=firmware-linux
>
> Micronit: any reason the lines are reordered here?

Mostly to differenciate between versioned and non-versioned package targets.

>> @@ -188,17 +188,17 @@ This is a packacked upstream version of the Linux kernel.
>>  The sources may be found at most Linux ftp sites, including:
>>  ftp://ftp.kernel.org/pub/linux/kernel
>>
>> -Copyright: 1991 - 2009 Linus Torvalds and others.
>> +Copyright: 1991-2012 Linus Torvalds and others.
>>
>> -The git repository for mainline kernel development is at:
>> -git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>> +The GIT repository for mainline kernel development is at:
>> +git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>
> I personally like to spell it as "Git". ;-)

That works for me too. Actually, what's the official spelling for it?

> [...]
>> @@ -273,6 +273,9 @@ if [ -e "$tmpdir/lib/firmware" ]; then
>>
>>  Package: $fwpackagename
>>  Architecture: all
>> +Conflicts: firmware-linux-free, firmware-linux-nonfree
>> +Provides: firmware-linux-free, firmware-linux-nonfree
>> +Replaces: firmware-linux-free, firmware-linux-nonfree
>
> I assume you mean Breaks+Replaces.  Do the files actually overlap,
> or is this change being overly cautious?  I would expect the files
> not to overlap because the package build with deb-pkg puts firmware
> in a versioned subdirectory "/lib/firmware/<version>".

AFAIK they would overlap, hence the Conflicts.

Martin-Éric
