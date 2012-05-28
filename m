Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2E1HLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 03:11:40 -0400
Received: from 7.mo3.mail-out.ovh.net ([46.105.57.200]:33418 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752812Ab2E1HLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 03:11:39 -0400
Date: Mon, 28 May 2012 09:03:36 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: T Makphaibulchoke <tmac@hp.com>
Cc: lethal@linux-sh.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kaloz@openwrt.org, matt.fleming@intel.com,
        lasse.collin@tukaani.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux@arm.linux.org.uk,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] lib/decompress_unxz.c: removing all memory helper
 functions
Message-ID: <20120528070336.GM3377@game.jcrosoft.org>
References: <1337875436-27640-1-git-send-email-tmac@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337875436-27640-1-git-send-email-tmac@hp.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2539467240755866443
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegjedrvdefucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegjedrvdefucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:03 Thu 24 May     , T Makphaibulchoke wrote:
> The patch cleans up the file lib/decompress_unxz.c by removing all memory
> helper functions, e.g., memmove.  By doing so, any architecture's preboot
> environment supporting the XZ decompression needs to define its own copy of
> any of the missing memory helper functions.
> 
> The patch makes sure that all 4 architectures' preboot currently supporting
> the XZ decompressor, arm, s390, sh and x86, build without error when using
> the XZ compression.
> 
> Adding a prototype for the memcmp function required by the XZ decompressor to
> workaround compiler's implicit type error.  Also removing both the memmove and
> memcpy defines workaround, to disable lib/decompress_unxz.c from duplicating
> both functions.
> 
> Adding the missing memcmp function, required by the XZ decompressor, to the
> s390 preboot environment.
> 
> Adding both the missing memmove and memcmp functions, required by the XZ
> decompressor, to the sh preboot environment.
> 
> Adding the missing memmove function, required by XZ decompressor, to the x86
> preboot environment.
> 
> Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
> ---
>  arch/arm/boot/compressed/decompress.c |    3 +-
>  arch/s390/boot/compressed/misc.c      |   14 +++++
>  arch/sh/boot/compressed/misc.c        |   32 ++++++++++++
>  arch/x86/boot/compressed/string.c     |   18 +++++++a
can we do not duplicate those functions?

Best Regards,
J.
