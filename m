Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab1LWUq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:46:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab1LWUq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:46:56 -0500
Date: Fri, 23 Dec 2011 15:46:09 -0500
From: Dave Jones <davej@redhat.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: Print PCI device in power management warning.
Message-ID: <20111223204608.GA24014@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Konrad Rzeszutek Wilk <konrad@darnok.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-pm@vger.kernel.org
References: <20111223181626.GA18647@redhat.com>
 <20111223202635.GA20991@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223202635.GA20991@andromeda.dapyr.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 04:26:35PM -0400, Konrad Rzeszutek Wilk wrote:
 
 > don't you just want:
 > 
 > 	WARN(ret && drv->driver.pm, "pci: %s Has both legacy and new PM
 > support!\n", drv_name(drv));
 > 
 > which will do what it previously does and also add the message you
 > wanted to add?

close. Not sure what drv_name() is, but I don't seem to have it in my tree.
This works though..

--- 

When the WARN_ON in pci_has_legacy_pm_support() triggers, we get
users filing backtraces, but it's not obvious which driver is
triggering the trace.  Printing the driver name in addition to the trace
should make these easier to debug.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 12d1e81..8af9ff2 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -604,7 +604,7 @@ static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
 	 * supported as well.  Drivers are supposed to support either the
 	 * former, or the latter, but not both at the same time.
 	 */
-	WARN_ON(ret && drv->driver.pm);
+	WARN(ret && drv->driver.pm, "pci: %s Has both legacy and new PM support!\n", drv->name);
 
 	return ret;
 }
