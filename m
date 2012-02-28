Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2B1Xlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 18:41:45 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:37089 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757480Ab2B1Xlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 18:41:44 -0500
Message-ID: <4F4D663D.2040100@xenotime.net>
Date: Tue, 28 Feb 2012 15:41:49 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Build regressions/improvements in v3.3-rc5 (C lang questions)
References: <1330462222-25201-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1330462222-25201-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 12:50 PM, Geert Uytterhoeven wrote:

> Below is the list of build error/warning regressions/improvements in
> v3.3-rc5[1] compared to v3.2[2].


>   + src/drivers/usb/misc/sisusbvga/sisusb.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 982
>   + src/fs/ecryptfs/miscdev.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 448, 488


Do the (2) above mean that some platform's gcc is borked?
(I don't see these on i386 or x86_64.)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


>   + src/fs/ecryptfs/miscdev.c: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int':  => 433, 433:60

I can see that warning on 32-bit i386 (X86_32), but if I change the
"%lu" to "%u", it causes this warning on 64-bit x86_64:

fs/ecryptfs/miscdev.c:433:38: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'long unsigned int'

so how is this supposed to be handled?

Thanks.

