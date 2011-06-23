Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab1FWQb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:31:56 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:57981 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758347Ab1FWQbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:31:53 -0400
Date: Thu, 23 Jun 2011 17:31:06 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-am33-list@redhat.com, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-arch@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] STAGING: Comedi: Build only on arches providing
 PAGE_KERNEL_NOCACHE
Message-ID: <20110623163105.GC16892@linux-mips.org>
References: <20110623114536.GA14011@linux-mips.org>
 <BANLkTimR98qo5fjMRf-kZahcA=hE-E3+Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimR98qo5fjMRf-kZahcA=hE-E3+Hg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 06:01:47PM +0200, Geert Uytterhoeven wrote:

> If only to get m68k/allmodconfig going again (hmm, there's another
> staging driver
> preventing a green light).

I ran into this doing an allyesconfig.  Allyesconfig has one disadvantage,
for choice it will only select the first or default option which means
that option gets exercised well and all the other options not at all.  On
MIPS that'd be IP22, 32-bit, R4x00, big endian, 4K pages, no multithreading,
250Hz.  Make randconfig disables lots of things so often misses the
opportunity to trigger some issues.

I'd really want an "make allrandconfig" which enables as many options as
possible but picks a random one from choice statements, something like that.

  Ralf
