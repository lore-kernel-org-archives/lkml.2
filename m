Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2KUOpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:45:17 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34444 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab2KUOpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:45:15 -0500
Date: Wed, 21 Nov 2012 14:50:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: roman@hodek.net
Cc: linux-kernel@vger.kernel.org, patrik.r.jakobsson@gmail.com,
        christian.gmeiner@gmail.com
Subject: Re:
Message-ID: <20121121145027.4dce136d@pyramind.ukuu.org.uk>
In-Reply-To: <20121121140442.782733@zweiblum.hodek.net>
References: <20121121140442.782733@zweiblum.hodek.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, the small LVDS one works fine so far, at least when I hardcode the
> panel resolution (there's no VBT etc. in BIOS yet). However, the SDVO one
> stays black. No wonder, as there's no SDVO code in the Oaktrail part of the
> driver.

Indeed - the Oaktrail processors don't have SDVO support. E6xx happens
to be very similar to Oaktrail so the LVDS works. No idea about HDMI.

> So I tried to add this... and simply started with adding a call to
> psb_intel_sdvo_init() in oaktrail_output_init(), to see what happens. The
> result: it doesn't find anything :-( I could track problems down to the point
> that the SDVO i2c registers seem to be the wrong ones.
> 
> At the known offsets for i2c regs (0x5100 and on) I see only 0xffffffff, so
> probably these registers are not present or somewhere else on my platform.
> 
> Does anybody of you have any infos on this? How can I get further?
> Thanks for any help in advance!

There is an Intel driver with open kernel code and proprietary userspace
for the Imagination 3D engine (EMGD) although only for an out of
maintenance Fedora and for Meego and in both cases for ancient kernels.

The fully open driver is built by extracting the relevant information and
code from these releases.

http://www.intel.com/p/en_US/embedded/hwsw/software/emgd#download


If you unpack that it contains a tar ball which you can unpack which
contains the driver.

emgd/pal/sdvo 

looks kind of promising.

