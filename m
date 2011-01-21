Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1AUQr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:47:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49702 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1AUQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:47:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
Subject: Re: [PATCH] adfs: add hexadecimal filetype suffix option
Date: Fri, 21 Jan 2011 17:47:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.5.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <4D2DEDDB.1070605@gmail.com> <20110119154915.a0bb2878.akpm@linux-foundation.org> <alpine.DEB.2.00.1101211431490.3490@dc5850.croftnuisk.local>
In-Reply-To: <alpine.DEB.2.00.1101211431490.3490@dc5850.croftnuisk.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101211747.17544.arnd@arndb.de>
X-Provags-ID: V02:K0:WX5AFsxPURrWVHTQ6GkUTH6Mb/smDDGNLn2cQMqjUUY
 gTzuOMhk5nUOPnJ+YVR5fUsb5u56MRnEE2fTXcrtP8dw3b074I
 eD3tNcF5S2A10srH40OneKPFzpNXpNldlFclVY16dzgTJ84Gsm
 3WkXdV6bJ6Tm3PwhOf185vhBWPzHnJAHka1FKfatXVatvyC8lF
 Uqi3c+pL2ebhK7HKCB7IQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 January 2011 15:34:12 Stuart Swales wrote:
> 
> [PATCH] adfs: add hexadecimal filetype suffix option
> 
> ADFS (FileCore) storage complies with the RISC OS filetype specification
> (12 bits of file type information is stored in the file load address, rather
> than using a file extension).  The existing driver largely ignores this
> information and does not present it to the end user.
> 
> It is desirable that stored filetypes be made visible to the end user to
> facilitate a precise copy of data and metadata from a hard disc (or image
> thereof) into a RISC OS emulator (such as RPCEmu) or to a network share which
> can be accessed by real Acorn systems.
> 
> This patch implements a per-mount filetype suffix option (use -o ftsuffix=1)
> to present any filetype as a ,xyz hexadecimal suffix on each file.  This type
> suffix is compatible with that used by RISC OS systems that access network
> servers using NFS client software and by RPCemu's host filing system.
> 
> Signed-off-by: Stuart Swales <stuart.swales.croftnuisk@gmail.com>

The patch looks fine to me, but it tells me that you have some knowledge
and interest in this file system. Adfs is currently one of only a handful
of modules in the kernel that still uses the big kernel lock, because
nobody so far had enough motivation to fix this.

Would you be able to take a look at this? The straightforward approach
would be to add a mutex to adfs_sb_info and use that in place of
lock_kernel. It's mostly a matter of testing to make sure that no
deadlocks get introduced in the process.

	Arnd
