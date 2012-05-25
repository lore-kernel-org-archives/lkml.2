Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab2EYIpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:45:33 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:6551 "EHLO mailfw02.zoner.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab2EYIp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:45:29 -0400
X-Greylist: delayed 650 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2012 04:45:28 EDT
Date: Fri, 25 May 2012 11:34:32 +0300
From: Lasse Collin <lasse.collin@tukaani.org>
To: T Makphaibulchoke <tmac@hp.com>
Cc: lethal@linux-sh.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kaloz@openwrt.org, matt.fleming@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux@arm.linux.org.uk, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com
Subject: Re: [PATCH] lib/decompress_unxz.c: removing all memory helper
 functions
Message-ID: <20120525113432.3beea6ed@tukaani.org>
In-Reply-To: <1337875436-27640-1-git-send-email-tmac@hp.com>
References: <1337875436-27640-1-git-send-email-tmac@hp.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-24 T Makphaibulchoke wrote:
> The patch cleans up the file lib/decompress_unxz.c by removing all
> memory helper functions, e.g., memmove.  By doing so, any
> architecture's preboot environment supporting the XZ decompression
> needs to define its own copy of any of the missing memory helper
> functions.

Is it best to copy these functions to each arch, or would it be better
to have a shared file from which these functions could be pulled for
multiple archs? I wasn't sure when I wrote decompress_unxz.c, which is
why I put the extra functions there as a temporary solution.

> Adding both the missing memmove and memcmp functions, required by the
> XZ decompressor, to the sh preboot environment.
> 
> Adding the missing memmove function, required by XZ decompressor, to
> the x86 preboot environment.

These already have memcpy. It can save a few bytes if one reused
memmove as memcpy when using XZ compression. I got a difference of 48
bytes on x86_64.

Adding memmove to string.c on x86 means that memmove is included in the
kernel image even when memmove isn't needed. With gzip compression I
got 128 bytes bigger image on x86_64 after adding the unneeded memmove
to string.c.

I don't know if those size increases matter in practice.

> + * To support XZ-decompressed file in preboot environment, the

s/XZ-decompressed/XZ-compressed/ :-)

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
