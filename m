Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2CNLUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:20:11 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43707 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2CNLUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:20:08 -0400
Date: Wed, 14 Mar 2012 11:21:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Januszewski <spock@gentoo.org>, linux-fbdev@vger.kernel.org,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH] x86: export 'pcibios_enabled'
Message-ID: <20120314112137.68fa4f70@pyramind.ukuu.org.uk>
In-Reply-To: <4F607A18.8080004@gmx.de>
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
	<4F5FAE63.3090908@xenotime.net>
	<4F5FE9AD.7000204@zytor.com>
	<20120314092955.2250a782@pyramind.ukuu.org.uk>
	<4F607A18.8080004@gmx.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > uvesafb could look for any PCI vga class device - which I suspect is
> > what it *should* be doing ?
> 
> Would this really change depending on whether the page is NX-protected
> or not?
> Your suggestion sounds like it is about detecting whether there is any
> graphic chip present or not while the patch is about fixing an oops
> caused by NX-protection of the BIOS.

Right yes.. I misunderstood what you are trying to do. I'd assumed you
wanted to find the ROM and thus set it to the right mapping mode.

You can use set_memory_x() to mark memory executable (and _nx to set it back).

If you really need to know if NX is being used then the check

	if (__supported_pte_mask & PTE_NX)

will do the trick and the variable is exported.

I'd suggest however you wrap that in a cpu_has_nx() type macro somewhere
in the arch headers.

If you go poking around pcibios values you are going to get burned if
someone is ever bored enough to make NX and PCIBIOS work together
differently.

Alan
