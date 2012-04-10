Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab2DJWsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:48:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59216 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab2DJWsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:48:14 -0400
Date: Wed, 11 Apr 2012 02:48:09 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120410224809.GM24857@moon>
References: <20120215143606.GA14037@redhat.com>
 <20120215160652.GA17680@redhat.com>
 <20120215162752.GF4533@moon>
 <20120409151027.7f3e0fa5.akpm@linux-foundation.org>
 <20120409222443.GW1625@moon>
 <4F836F3E.9090207@zytor.com>
 <20120410223758.GL24857@moon>
 <4F84B6B9.9080701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F84B6B9.9080701@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 03:39:53PM -0700, H. Peter Anvin wrote:
> On 04/10/2012 03:37 PM, Cyrill Gorcunov wrote:
> > + * bits even more (the oddity is important here, it allow
> > + * us to have meaningful production even if multiplicants
> > + * are big numbers).
> 
> I would be more clear:
> 
> "the odd multiplier guarantees that the product is unique ever after the
> high bits are truncated, since any odd number is relative prime to 2^n".
> 

Yeah, updated, thanks. Andrew, fold it up please.

---
Subject: Add a comment on kcmp obfuscation method

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
---
 kernel/kcmp.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.git/kernel/kcmp.c
===================================================================
--- linux-2.6.git.orig/kernel/kcmp.c
+++ linux-2.6.git/kernel/kcmp.c
@@ -17,6 +17,17 @@
  * reasons, still the comparison results should be suitable for
  * sorting. Thus, we obfuscate kernel pointers values and compare
  * the production instead.
+ *
+ * The obfuscation is done in two steps. First -- we use xor on
+ * kernel pointer with random value, which puts pointer into
+ * a new position in reordered space. Second -- we multiply
+ * the xor production with big odd random number to permute
+ * bits even more (the odd multiplier guarantees that the product
+ * is unique ever after the high bits are truncated, since any odd
+ * number is relative prime to 2^n).
+ *
+ * Note also the obfuscation itself is invisible to user-space
+ * and if needed it can be changed to any suitable scheme.
  */
 static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
 
