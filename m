Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab0EYTYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:24:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab0EYTYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:24:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for May 25 (kernel/power, SUSPEND=n)
Date: Tue, 25 May 2010 21:24:52 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-pm@lists.linux-foundation.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20100525142657.c2ae7804.sfr@canb.auug.org.au> <20100525084959.4ff9e924.randy.dunlap@oracle.com>
In-Reply-To: <20100525084959.4ff9e924.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005252124.52108.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010, Randy Dunlap wrote:
> On Tue, 25 May 2010 14:26:57 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > We are in the merge window again.  I remind you all not to add stuff for
> > 2.6.36 to your linux-next trees until after 2.6.35-rc1.
> 
> 
> when CONFIG_SUSPEND=n, CONFIG_OPPORTUNISTIC_SUSPEND=n, CONFIG_PM=y:
> 
> kernel/power/main.c:66: error: 'pm_states' undeclared (first use in this function)

Thanks, the patch below fixes this.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Fix build with CONFIG_SUSPEND unset

If CONFIG_SUSPEND is unset, pm_state_valid() doesn't build because
the pm_states[] array is not defined, but pm_state_valid() is only
used under #ifdef CONFIG_SUSPEND, so don't try to build it if
CONFIG_SUSPEND is unset.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -61,10 +61,12 @@ static inline int pm_enter_state(int sta
 
 static inline bool hibernation_supported(void) { return true; }
 
+#ifdef CONFIG_SUSPEND
 static inline bool pm_state_valid(int state_idx)
 {
 	return pm_states[state_idx] && valid_state(state_idx);
 }
+#endif /* CONFIG_SUSPEND */
 
 static inline int pm_enter_state(int state_idx)
 {
