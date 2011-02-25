Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab1BYPDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:03:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287Ab1BYPDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:03:07 -0500
Message-ID: <4D67C4A6.9050006@suse.com>
Date: Fri, 25 Feb 2011 10:03:02 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
References: <4D671667.4000602@suse.com> <4D67378C.30506@msgid.tls.msk.ru>
In-Reply-To: <4D67378C.30506@msgid.tls.msk.ru>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/25/2011 12:01 AM, Michael Tokarev wrote:
> 25.02.2011 05:39, Jeff Mahoney wrote:
>>  Every kernel package trying to provide files under /lib/firmware runs
>>  into problems really quickly with multiple kernels installed.
> 
> Which problems?
> 
>>  This patch moves them to /lib/firmware/$KERNELRELEASE. udev v127's
>>  firmware.sh looks there first before falling back to /lib/firmware.
> 
> This was the way it worked before, -- all fw in kernel-specific dir.
> Nowadays it moved to a common place, /lib/firmware, since the blobs
> there are not kernel-specific but hardware-specific.  And now you
> propose to move it back.  Why?

Because every time you run 'make modules_install', it overwrites
whatever is in /lib/firmware when there is a collision. When you're
working with multiple kernel versions, you can end up with firmware
blobs from older builds, and that may not be what you want. If the right
answer is to always use kernel-firmware, then the firmwares should
probably not be in the kernel tree at all.

As I mentioned in the header, udev looks in /lib/firmware/$(uname -r)
already. Since Aug 2008, in fact.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk1nxKYACgkQLPWxlyuTD7KohACfRmDshnoXwVTpSs+xblUfQSKQ
svkAnikK8sk7S6Fd8NKT1Ui2ugaP7IzC
=odyW
-----END PGP SIGNATURE-----
