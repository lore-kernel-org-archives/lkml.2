Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1B1C27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 21:28:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:8010 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab1B1C25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 21:28:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,237,1297065600"; 
   d="scan'208";a="891793886"
Subject: Re: linux-next: build failure after merge of the final tree (kvm
 tree related)
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110228131556.3822f3ca.sfr@canb.auug.org.au>
References: <20110221175658.2dc4d1ac.sfr@canb.auug.org.au>
	 <20110228131556.3822f3ca.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 10:28:44 +0800
Message-ID: <1298860124.27725.2.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Avi and Marcelo,

On Mon, 2011-02-28 at 10:15 +0800, Stephen Rothwell wrote:
> Hi All,
> 
> On Mon, 21 Feb 2011 17:56:58 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the final tree, today's linux-next build (sparc64 defconfig)
> > failed like this:
> > 
> > mm/memory.c: In function '__get_user_pages':
> > mm/memory.c:1584: error: 'EHWPOISON' undeclared (first use in this function)
> > 
> > Caused by commit b1c4f2836370f5c8207d4c61e91c93bd6a4ce27a ("mm: make
> > __get_user_pages return -EHWPOISON for HWPOISON page optionally") from
> > the kvm tree.
> > 
> > Not all architectures use include/asm-generic/errno.h ...
> > 
> > I have reverted that commit (and commits
> > d47b742c5661385b927c03188549b2d2004b80f4 "KVM: Replace
> > is_hwpoison_address with __get_user_pages" and
> > eef8839430b72deac59e9ec51eb56c44512fcc66 "mm: remove is_hwpoison_address"
> > which depend on it) for today.
> 
> I am still doing those reverts ...

Can you merge the fixes following the email into my original EHWPOISON
patch to check if that fixes linux-next issue?

Or you prefer I resend the patchset?

Best Regards,
Huang Ying

---
 arch/alpha/include/asm/errno.h  |    2 ++
 arch/mips/include/asm/errno.h   |    2 ++
 arch/parisc/include/asm/errno.h |    2 ++
 arch/sparc/include/asm/errno.h  |    2 ++
 4 files changed, 8 insertions(+)

--- a/arch/parisc/include/asm/errno.h
+++ b/arch/parisc/include/asm/errno.h
@@ -122,4 +122,6 @@
 
 #define	ERFKILL		256	/* Operation not possible due to RF-kill */
 
+#define EHWPOISON	257	/* Memory page has hardware error */
+
 #endif
--- a/arch/sparc/include/asm/errno.h
+++ b/arch/sparc/include/asm/errno.h
@@ -112,4 +112,6 @@
 
 #define	ERFKILL		134	/* Operation not possible due to RF-kill */
 
+#define EHWPOISON	135	/* Memory page has hardware error */
+
 #endif
--- a/arch/alpha/include/asm/errno.h
+++ b/arch/alpha/include/asm/errno.h
@@ -122,4 +122,6 @@
 
 #define	ERFKILL		138	/* Operation not possible due to RF-kill */
 
+#define EHWPOISON	139	/* Memory page has hardware error */
+
 #endif
--- a/arch/mips/include/asm/errno.h
+++ b/arch/mips/include/asm/errno.h
@@ -121,6 +121,8 @@
 
 #define	ERFKILL		167	/* Operation not possible due to RF-kill */
 
+#define EHWPOISON	168	/* Memory page has hardware error */
+
 #define EDQUOT		1133	/* Quota exceeded */
 
 #ifdef __KERNEL__


