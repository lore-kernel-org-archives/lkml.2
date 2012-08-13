Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab2HMSOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:14:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:35465 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab2HMSOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,761,1336374000"; 
   d="scan'208";a="199929596"
Date: Tue, 14 Aug 2012 02:13:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, kernel-janitors@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [userns:userns-always-map-user-v45 80/99] fs/namespace.c:2290:1:
 error: unknown type name 'atomic64_t'
Message-ID: <20120813181343.GA2055@localhost>
References: <20120812145023.GA17077@localhost>
 <87k3x3z3de.fsf@xmission.com>
 <20120813133910.GA30532@localhost>
 <63f9e712-3cd1-4020-9df6-8fb8d9c3f1ec@email.android.com>
 <20120813175516.GA32757@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813175516.GA32757@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 01:55:16AM +0800, Fengguang Wu wrote:
> > >I'd suggest to fix it in m68k and make atomic64_t generally available.
> > 
> > Fengguang in your testing on any architechtures is atomic64_t missing on anything except some m68k subarchtechtures?
> 
> Eric, it only complaints for m68k, among the architechtures the build
> tests covered (alpha arm avr32 blackfin cris frv h8300 i386 ia64 m32r
> m68k mips mn10300 openrisc parisc powerpc s390 sh sparc sparc64 tile
> um x86_64 xtensa).

Sorry, I must missed something (in my system, build errors are only
recorded on first sight)..

wfg /c/linux% for arch in arch/*/; do grep -ir -q atomic64 $arch || echo $arch; done
arch/c6x/
arch/h8300/
arch/mn10300/
arch/score/
arch/unicore32/

So the above archs are likely still missing atomic64_t support.
However it should be trivial to add support to them, by adding
"select GENERIC_ATOMIC64" lines to them.

Thanks,
Fengguang
