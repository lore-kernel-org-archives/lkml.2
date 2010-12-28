Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0L1A1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 19:27:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:30850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0L1A1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 19:27:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,237,1291622400"; 
   d="scan'208";a="872301230"
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <20101227121454.GB488@htj.dyndns.org>
References: <4D073FA9.9020801@gmail.com>
	 <1292378268.2323.464.camel@sli10-conroe> <4D08CBF4.6040102@gmail.com>
	 <1292460817.2323.465.camel@sli10-conroe>
	 <20101216054620.GA3241@merkur.ravnborg.org>
	 <1292479000.2323.468.camel@sli10-conroe> <4D09E0EE.7040605@gmail.com>
	 <1292808518.10593.8.camel@sli10-conroe> <4D0F7C5A.1060107@gmail.com>
	 <1293071914.10593.10.camel@sli10-conroe>
	 <20101227121454.GB488@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 08:26:57 +0800
Message-ID: <1293496017.10593.26.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-27 at 20:14 +0800, Tejun Heo wrote:
> On Thu, Dec 23, 2010 at 10:38:34AM +0800, Shaohua Li wrote:
> > The first patch in the series isn't related to this issue, please
> > consider merge it.
> 
> Can you please re-post it?  Thanks.
here it is.

Subject: make readmostly section correctly align

readmostly section should end at cache line aligned address, otherwise the last
several data might share cachline with other data and make the readmostly data
still have cache bounce.
For example, in ia64, secpath_cachep is the last readmostly data, and it shares
cacheline with init_uts_ns.
a000000100e80480 d secpath_cachep
a000000100e80488 D init_uts_ns

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 include/asm-generic/vmlinux.lds.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux.orig/include/asm-generic/vmlinux.lds.h	2010-12-01 16:49:48.000000000 +0800
+++ linux/include/asm-generic/vmlinux.lds.h	2010-12-02 09:22:32.000000000 +0800
@@ -192,7 +192,8 @@
 
 #define READ_MOSTLY_DATA(align)						\
 	. = ALIGN(align);						\
-	*(.data..read_mostly)
+	*(.data..read_mostly)						\
+	. = ALIGN(align);
 
 #define CACHELINE_ALIGNED_DATA(align)					\
 	. = ALIGN(align);						\


