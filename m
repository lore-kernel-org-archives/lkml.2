Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab1D0SZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:25:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35662 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab1D0SZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=RCg9cKTYTw0TIWVM6qOWEa1goi/4p4xlfyTR2CrVirehQsgkWw4haDGaNia3Ru1uCs
         4Ex7KP/pwTVjDsZDInbAiC918n5BiBHlUcx2uRfcLOiFiugtLXAx9atq+4OVMVGMySxt
         eYMT0acL2fYf6AOaLvTqmScQTE2V6L2og2TNk=
MIME-Version: 1.0
In-Reply-To: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 27 Apr 2011 14:25:17 -0400
X-Google-Sender-Auth: FTW3V2HHDPxHxWSxQbAi17h11yI
Message-ID: <BANLkTinG+ooNRH-VUjKdaHixbGCwk5XoXA@mail.gmail.com>
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
To: Andrea Righi <andrea@betterlinux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 14:13, Andrea Righi wrote:
> Introduce a new fadvise flag to drop page cache pages of a single
> filesystem.
>
> At the moment it is possible to drop page cache pages via
> /proc/sys/vm/drop_pagecache or via posix_fadvise(POSIX_FADV_DONTNEED).
>
> The first method drops the whole page cache while the second can be used
> to drop page cache pages of a single file descriptor. However, there's
> not a simple way to drop all the pages of a filesystem (we could scan
> all the file descriptors and use posix_fadvise(POSIX_FADV_DONTNEED), but
> this solution obviously doesn't scale well).

what if you open the mount point and use POSIX_FADV_DONTNEED on that
dir handle ?  if you required write access for that level, it'd also
implicitly take care of the permission issue.  but maybe this is just
trying to fit existing code in the wrong way.
-mike
