Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2FLR02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:26:28 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58494 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2FLR00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:26:26 -0400
Date: Tue, 12 Jun 2012 13:26:22 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Lasse Collin <lasse.collin@tukaani.org>
cc: T Makphaibulchoke <tmac@hp.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        lethal@linux-sh.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kaloz@openwrt.org, jj@chaosbits.net,
        matt.fleming@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
 functions
In-Reply-To: <20120612191804.4211462a@tukaani.org>
Message-ID: <alpine.LFD.2.02.1206121316190.23555@xanadu.home>
References: <1339470307-28223-1-git-send-email-tmac@hp.com> <20120612191804.4211462a@tukaani.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012, Lasse Collin wrote:

> On 2012-06-11 T Makphaibulchoke wrote:
> > +#ifndef __HAVE_PREBOOT_ARCH_MEMMOVE
> > +void *memmove(void *__dest, __const void *__src, size_t count)
> > +{
> > +	unsigned char *d = __dest;
> > +	const unsigned char *s = __src;
> > +
> > +	if (__dest == __src)
> > +		return __dest;
> > +
> > +	if (__dest < __src)
> > +		return memcpy(__dest, __src, count);
> > +
> > +	while (count--)
> > +		d[count] = s[count];
> > +	return __dest;
> > +}
> > +#endif
> 
> The use of memcpy when __dest < __src is OK with some memcpy
> implementations, but in a generic case it isn't guaranteed to work.

Of course, if the memcpy implementation is also provided along with this 
memmove code, as it was the case on ARM before this patch, then you can 
guarantee it.  And if that memcpy() happens to be slightly more 
optimized then this is a win.

> I think it would be better to just copy memmove from lib/string.c.

Instead of copying, maybe this would be much better to make the content 
of lib/string.c usable in a pre-boot environment.


Nicolas
