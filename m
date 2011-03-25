Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1CYEoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 00:44:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52511 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab1CYEob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 00:44:31 -0400
Date: Fri, 25 Mar 2011 15:44:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Paul Fox <pgf@laptop.org>
Subject: Re: linux-next: build failure after merge of the drivers-x86 tree
Message-Id: <20110325154421.1c328ee2.sfr@canb.auug.org.au>
In-Reply-To: <20110214163944.53c1241d.sfr@canb.auug.org.au>
References: <20110214163944.53c1241d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Mon, 14 Feb 2011 16:39:44 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> After merging the drivers-x86 tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/platform/x86/xo15-ebook.c: In function 'ebook_switch_add':
> drivers/platform/x86/xo15-ebook.c:136: error: 'struct acpi_device_wakeup' has no member named 'run_wake_count'
> 
> Caused by commit f160ad4c2a720411a136db7b867c3b4b868b8933 ("OLPC XO-1.5
> ebook switch driver") interacting with commit
> 0cab2dcf9963b1a7ed32e730384e1e8925b099cd ("ACPI: Remove the
> wakeup.run_wake_count device field") from the acpi tree.

This acpi commit has now been merged into Linus' tree (as commit
5190726765b4) so the patch below can now be applied to the drivers-x86
tree (after merging Linus' tree).  Or should be sent to Linus along with
your merge request.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 14 Feb 2011 16:36:41 +1100
Subject: [PATCH] OLPC: fix for removal of run_wake_count

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/platform/x86/xo15-ebook.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/xo15-ebook.c b/drivers/platform/x86/xo15-ebook.c
index 2343bb3..c1372ed 100644
--- a/drivers/platform/x86/xo15-ebook.c
+++ b/drivers/platform/x86/xo15-ebook.c
@@ -133,7 +133,6 @@ static int ebook_switch_add(struct acpi_device *device)
 		/* Button's GPE is run-wake GPE */
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
-		device->wakeup.run_wake_count++;
 		device_set_wakeup_enable(&device->dev, true);
 	}
 
-- 
1.7.2.3


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
