Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2FLRpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:45:06 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52411 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2FLRpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:45:03 -0400
Date: Tue, 12 Jun 2012 13:44:59 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Lasse Collin <lasse.collin@tukaani.org>, T Makphaibulchoke <tmac@hp.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        lethal@linux-sh.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kaloz@openwrt.org, jj@chaosbits.net,
        matt.fleming@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
 functions
In-Reply-To: <4FD77CAF.1020402@zytor.com>
Message-ID: <alpine.LFD.2.02.1206121336060.23555@xanadu.home>
References: <1339470307-28223-1-git-send-email-tmac@hp.com> <20120612191804.4211462a@tukaani.org> <alpine.LFD.2.02.1206121316190.23555@xanadu.home> <4FD77CAF.1020402@zytor.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012, H. Peter Anvin wrote:

> On 06/12/2012 10:26 AM, Nicolas Pitre wrote:
> > 
> > Instead of copying, maybe this would be much better to make the content 
> > of lib/string.c usable in a pre-boot environment.
> > 
> 
> Not sure about that... a lot of it is #ifndef __HAVE_ARCH_* and you
> *really* want those optimizations on some arches.

Sure.  What about:

lib/boot/mem.c: lib/string.c
	sed 's/^#ifndef __HAVE_ARCH_/#ifndef __HAVE_PREBOOT_ARCH_/' < $< > $@

This is over simplified but you get the idea.  Maybe lib/string.c itself 
should be split into several files to help with a finer grained 
selection.


Nicolas
