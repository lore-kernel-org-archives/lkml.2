Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2KUMgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:36:52 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34221 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2KUMgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:36:50 -0500
Date: Wed, 21 Nov 2012 12:42:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v3] devtmpfs: mount with noexec and nosuid
Message-ID: <20121121124204.1fbd690c@pyramind.ukuu.org.uk>
In-Reply-To: <20121121064450.GB3620@mobil.systemanalysen.net>
References: <20121120215059.GA1859@www.outflux.net>
	<20121121064450.GB3620@mobil.systemanalysen.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	  This instructs the kernel to include the MS_NOEXEC and MS_NOSUID mount
> 	  flags when mounting devtmpfs.

So does a mount syscall

> 	  In-kernel separation of executable and non-executable code combined
> 	  with a proper executability policy is a basic technique to protect
> 	  against exploits by buggy or malicious code or hardware errors.  In
> 	  terms of overhead it is a low-cost-high-effect technique especially on
> 	  platforms with dedicated hardware support, e.g. x86_64 (look for "NX"
> 	  feature in BIOS settings).  Mounting devtmpfs with MS_NOEXEC flag is
> 	  an essential building-block for this security technique.

Which is done via a mount syscall

> 
> 	  Notice:  If enabled, software which depends on execution of
> 	  runtime-generated code can only be used with restricted feature set or
> 	  not at all, e.g. proprietary video drivers, JIT-compilers, most modern
> 	  web browsers.  The grsecurity-patchset provides exception mechanisms to
> 	  solve this problem for e.g. desktop systems.

We don't generally advertise random third party patches in Kconfig
> 
> 	  For server and embedded systems with HA-requirements consider Y.

That is totally misleading. HA has no connection to security and sever
and most embedded systems have nothing to gain from this feature as they
have both other writable storage and interpreters available. So if you
are attacking a server box you don't care about noexec, you feed the
script to perl.

NAK
