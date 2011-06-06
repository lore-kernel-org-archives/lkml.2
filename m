Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1FFR4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:56:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60274 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1FFR4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:56:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 5/8] PCI / Intel IOMMU: Use syscore_ops instead of sysdev class and sysdev
Date: Mon, 6 Jun 2011 19:57:35 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>, linux-pci@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103122218.14832.rjw@sisk.pl> <BANLkTi=xhg7_0O-aVC8s1Uyo4Wkz5OTCdg@mail.gmail.com>
In-Reply-To: <BANLkTi=xhg7_0O-aVC8s1Uyo4Wkz5OTCdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061957.35413.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 02, 2011, Tony Luck wrote:
> On Sat, Mar 12, 2011 at 1:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > -static int __init init_iommu_sysfs(void)
> > -{
> > -       return 0;
> > -}
> > +static inline int init_iommu_pm_ops(void) { }
> >  #endif /* CONFIG_PM */
> 
> drivers/pci/intel-iommu.c:3391: warning: no return statement in
> function returning non-void
> 
> s/static inline int/static inline void/
> 
> Reported-by: Tony Luck <tony.luck@intel.com>

I guess you mean the following?

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

If CONFIG_PM is not set, init_iommu_pm_ops() introduced by commit
134fac3f457f3dd753ecdb25e6da3e5f6629f696 (PCI / Intel IOMMU: Use
syscore_ops instead of sysdev class and sysdev) is not defined
appropriately.  Fix this issue.

Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c
+++ linux-2.6/drivers/pci/intel-iommu.c
@@ -3388,7 +3388,7 @@ static void __init init_iommu_pm_ops(voi
 }
 
 #else
-static inline int init_iommu_pm_ops(void) { }
+static inline void init_iommu_pm_ops(void) {}
 #endif	/* CONFIG_PM */
 
 /*
