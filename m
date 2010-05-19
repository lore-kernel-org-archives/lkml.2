Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab0ESPy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:54:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45653 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0ESPy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:54:57 -0400
Date: Thu, 20 May 2010 01:54:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 16/17] acpi: update gfp/slab.h includes
Message-Id: <20100520015455.bee01631.sfr@canb.auug.org.au>
In-Reply-To: <1269885165-18617-17-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-17-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On Tue, 30 Mar 2010 02:52:44 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.

Please apply this to the acpi tree (patch reposted below).

From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>
Subject: [PATCH 16/17] acpi: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:44 +0900

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/apei/apei-base.c |    1 +
 drivers/acpi/atomicio.c       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index c35fec7..2672880 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
+#include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/kref.h>
 #include <linux/rculist.h>
diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
index 4ed1385..e21b1e4 100644
--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -31,6 +31,7 @@
 #include <linux/kref.h>
 #include <linux/rculist.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 #include <acpi/atomicio.h>
 
 #define ACPI_PFX "ACPI: "
-- 
1.6.4.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
