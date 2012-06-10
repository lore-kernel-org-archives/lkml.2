Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2FJVuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 17:50:54 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:1725 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803Ab2FJVux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 17:50:53 -0400
Message-ID: <1339365045.30984.78.camel@x61.thuisdomein>
Subject: blackfin: how is the I-pipe code supposed to be built?
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Sun, 10 Jun 2012 23:50:45 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 10 Jun 2012 21:50:45.0547 (UTC) FILETIME=[16E35FB0:01CD4753]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) While working my way through the stack of apparently unused headers I
also looked at arch/blackfin/include/asm/ipipe_base.h, as nothing seems
to include that header. The last include of that file got removed in
commit 1353d050facf5efd8dc05ba6c4d7852fcb423b15 ("Blackfin/ipipe:
restore pipeline bits in irqflags"). So that header is unused since
v2.6.39.

1) Before submitting the (possibly trivial) patch to remove that header
I did some further research, because I wanted to be sure that removing
this header was a reasonable thing to do.

2) I learned that arch/blackfin/include/asm/ipipe_base.h got added to
the tree in commit 6a01f230339321292cf065551f8cf55361052461 ("Blackfin
arch: merge adeos blackfin part to arch/blackfin/"). That commit also
introduced the macro CONFIG_IPIPE. But it did not introduce the Kconfig
symbol IPIPE. (Neither did it add code that defines a macro
CONFIG_IPIPE.) So to me it looks like the I-pipe code got added to
v2.6.29 without proper Kbuild support.

3) And this is currently still the case. There seem to be no Kconfig
symbols IPIPE, IPIPE_DEBUG, IPIPE_DEBUG_CONTEXT, or IPIPE_TRACE_IRQSOFF.
(Neither seems there to be code that defines the macros CONFIG_IPIPE,
CONFIG_IPIPE_DEBUG, CONFIG_IPIPE_DEBUG_CONTEXT, or
CONFIG_IPIPE_TRACE_IRQSOFF.)

4) Whether or not arch/blackfin/include/asm/ipipe_base.h should be
removed isn't very interesting. What is more interesting is how the
blackfin I-pipe code is supposed to be built. How can this code be built
from what currently is in mainline?


Paul Bolle

