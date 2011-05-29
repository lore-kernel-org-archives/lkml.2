Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1E2QOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 12:14:55 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:51222 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab1E2QOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 12:14:53 -0400
Message-ID: <4DE270FA.6060702@msgid.tls.msk.ru>
Date: Sun, 29 May 2011 20:14:50 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: unlink(nonexistent): EROFS or ENOENT?
References: <4DE26F97.9050607@msgid.tls.msk.ru>
In-Reply-To: <4DE26F97.9050607@msgid.tls.msk.ru>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

29.05.2011 20:08, Michael Tokarev пишет:
> Hello.
> 
> Just noticed that at least on ext4, unlinking a
> non-existing file from a read-only filesystem
> results in EROFS instead of ENOENT.  I'd expect
> it return ENOENT - it is more logical, at least
> in my opinion.

http://pubs.opengroup.org/onlinepubs/009695399/functions/unlink.html
this case is quite clear:

 [EROFS]
    The directory entry to be unlinked
    is part of a read-only file system

Ie, the entry is a _part_ of a file system, so it should be
_existing_ entry to start with.

> For one, (readonly) NFS mount returns ENOENT in
> this case.
> 
> Thanks!

/mjt
