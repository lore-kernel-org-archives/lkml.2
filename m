Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1FGOQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:16:25 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:35860 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab1FGOQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:16:24 -0400
Message-ID: <4DEE32B4.509@msgid.tls.msk.ru>
Date: Tue, 07 Jun 2011 18:16:20 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk
Subject: Re: [PATCH -v3] vfs: make unlink() and rmdir() return ENOENT in preference
 to EROFS
References: <4DED5926.80504@msgid.tls.msk.ru> <1307402380-14166-1-git-send-email-tytso@mit.edu>
In-Reply-To: <1307402380-14166-1-git-send-email-tytso@mit.edu>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.06.2011 03:19, Theodore Ts'o wrote:
> If user space attempts to remove a non-existent file or directory, and
> the file system is mounted read-only, return ENOENT instead of EROFS.
> Either error code is arguably valid/correct, but ENOENT is a more
> specific error message.
> 
> Reported-by: Michael Tokarev <mjt@tls.msk.ru>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Thank you very much for this patch.  I had no chance to test it before,
now I've tested it and it works as expected - now both rm(1) and rmdir(1)
behave correctly, and git rm works too.

It's interesting to note that it's been this way for several years
(when the change occured?), and there has been no complains so far... ;)

Thanks!

/mjt
