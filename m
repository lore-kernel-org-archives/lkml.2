Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1BFWiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:38:22 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:33313 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab1BFWiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:38:21 -0500
Date: Sun, 6 Feb 2011 14:38:16 -0800
From: Andres Salomon <dilinger@queued.net>
To: Greg KH <gregkh@suse.de>
Cc: Marek Belisko <marek.belisko@open-nandra.com>, cjb@laptop.org,
        jon.nettleton@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] olpc_dcon: revert strtoul change
Message-ID: <20110206143816.0355ddc5@queued.net>
In-Reply-To: <20110204234443.GB4147@suse.de>
References: <1296746572-8998-1-git-send-email-marek.belisko@open-nandra.com>
	<20110204152341.7b869851@debxo>
	<20110204234443.GB4147@suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011 15:44:43 -0800
Greg KH <gregkh@suse.de> wrote:

> On Fri, Feb 04, 2011 at 03:23:41PM -0800, Andres Salomon wrote:
> > No opinions on this patch (there are some things I'd do differently,
> > but overall it looks fine).  I'd just like to ensure that if it's
> > merged, it gets into Linus's tree quickly so that the DCON reworking
> > that I'm planning to do doesn't get sidetracked by conflicts.
> 
> It is planned to go to Linus for .39 and is now in the linux-next tree
> as of tomorrow.
> 
> thanks,
> 
> greg k-h


Ugh, this actually causes build warnings and causes XOs to fail to
boot.  Seems like the strict_strtoul change broke things; this patch
backs that out.  We can fix it properly later.
Greg, can you please apply?



From: Andres Salomon <dilinger@queued.net>

The s/simple_strtoul/strict_strtoul/ from commit e107e6eb added a build
warning, as well as an oops.  This reverts that change.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index b19cd34..d6ad5d7 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -525,7 +525,7 @@ static int _strtoul(const char *buf, int len, unsigned int *val)
 {
 
 	char *endp;
-	unsigned int output = strict_strtoul(buf, &endp, 0);
+	unsigned int output = simple_strtoul(buf, &endp, 0);
 	int size = endp - buf;
 
 	if (*endp && isspace(*endp))
-- 
1.7.2.3

