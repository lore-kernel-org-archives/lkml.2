Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1G2UiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 16:38:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:40579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab1G2UiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 16:38:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,288,1309762800"; 
   d="scan'208";a="33645163"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [RFD] Direct support for the x86 RDRAND instruction
Date: Fri, 29 Jul 2011 13:37:45 -0700
Message-Id: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

This is a proposed patchset to enable the new x86 RDRAND instruction,
labelled "Bull Mountain Technology" by Intel.  It is a different beast
than any other hardware random number generator that I have personally
encountered: it is not just a random number source, but contains a
high bandwidth random number generator, an AES cryptographic whitener,
and integrity monitoring all in hardware.

For technical documentation see:

http://software.intel.com/en-us/articles/download-the-latest-bull-mountain-software-implementation-guide/

This proposed patchset enables RDRAND bypass for current users of the
nonblocking random pool (that is, for /dev/urandom and its equvalent
in-kernel users) but not for the blocking pool (/dev/random).  This is
because RDRAND, although reseeded way more frequently than what is
practical to do in software, is technically a nonblocking source that
can behave as a PRNG.  It can be used as a source for randomness for
/dev/random, but that is not addressed by this patchset.
