Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3AHC0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:26:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:17287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab3AHC0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:26:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,428,1355126400"; 
   d="scan'208";a="271104125"
Date: Tue, 8 Jan 2013 10:26:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <koverstreet@google.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [avr32] [next:akpm 212/227] lib/percpu-refcount.c:57: warning: value
 computed is not used
Message-ID: <20130108022614.GD5368@localhost>
References: <50ea52f0.69PJ2c5Grhsxkqtb%fengguang.wu@intel.com>
 <20130107122052.049f8867.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107122052.049f8867.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC avr32 maintainers]

On Mon, Jan 07, 2013 at 12:20:52PM -0800, Andrew Morton wrote:
> On Mon, 07 Jan 2013 12:45:36 +0800
> kbuild test robot <fengguang.wu@intel.com> wrote:
> 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
> > head:   e862d51dae9808e394a118ca1692f09bf0751aba
> > commit: 6311ac08e93b12f1367da092b413dd2434be45f5 [212/227] generic dynamic per cpu refcounting
> > config: make ARCH=avr32 atngw100_defconfig
> > 
> > All warnings:
> > 
> > lib/percpu-refcount.c: In function 'percpu_ref_init':
> > lib/percpu-refcount.c:22: error: 'jiffies' undeclared (first use in this function)
> > lib/percpu-refcount.c:22: error: (Each undeclared identifier is reported only once
> > lib/percpu-refcount.c:22: error: for each function it appears in.)
> > lib/percpu-refcount.c: In function 'percpu_ref_alloc':
> > lib/percpu-refcount.c:36: error: 'jiffies' undeclared (first use in this function)
> > lib/percpu-refcount.c:41: error: 'HZ' undeclared (first use in this function)
> > lib/percpu-refcount.c:57: warning: value computed is not used
> > 
> 
> Confused. 
> http://ozlabs.org/~akpm/mmotm/broken-out/generic-dynamic-per-cpu-refcounting-fix.patch
> added the jiffies.h include.

Oh that patch's linux-next commit is 18bc58821de88e5621cfdaac78c814ea479accab
and goes _after_ the current commit 6311ac08e93b12f1367da092b413dd2434be45f5.

So linux-next HEAD no longer has the build errors, however I still got these
warnings:

          CC      lib/percpu-refcount.o
        In file included from /c/wfg/linux/include/uapi/linux/param.h:4,
                         from /c/wfg/linux/include/linux/timex.h:63,
                         from /c/wfg/linux/include/linux/jiffies.h:8,
                         from /c/wfg/linux/lib/percpu-refcount.c:4:
==>     /c/wfg/linux/arch/avr32/include/asm/param.h:6:1: warning: "HZ" redefined

That's a trivial avr32 problem.

        In file included from /c/wfg/linux/arch/avr32/include/asm/param.h:4,
                         from /c/wfg/linux/include/uapi/linux/param.h:4,
                         from /c/wfg/linux/include/linux/timex.h:63,
                         from /c/wfg/linux/include/linux/jiffies.h:8,
                         from /c/wfg/linux/lib/percpu-refcount.c:4:
        /c/wfg/linux/arch/avr32/include/uapi/asm/param.h:6:1: warning: this is the location of the previous definition
        /c/wfg/linux/lib/percpu-refcount.c: In function 'percpu_ref_alloc':
==>     /c/wfg/linux/lib/percpu-refcount.c:58: warning: value computed is not used

That's perhaps related to how cmpxchg() is expanded in avr32.

        /c/wfg/linux/lib/percpu-refcount.c: In function 'percpu_ref_kill':
==>     /c/wfg/linux/lib/percpu-refcount.c:114: warning: 'new' may be used uninitialized in this function

Should be a false warning. The code looks fine.

Thanks,
Fengguang
