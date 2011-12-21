Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1LUBhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:37:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45587 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956Ab1LUBhb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:37:31 -0500
Message-ID: <1324431446.2844.155.camel@deadeye>
Subject: [PATCH 8/8] pmcraid: Pass pointers to access_ok(), not integers
From: Ben Hutchings <ben@decadent.org.uk>
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 01:37:26 +0000
In-Reply-To: <1324430940.2844.144.camel@deadeye>
References: <1324430940.2844.144.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures define access_ok() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on sparc64.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/pmcraid.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 5163edb..01b29a6 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3807,7 +3807,8 @@ static long pmcraid_ioctl_passthrough(
 	}
 
 	if (request_size > 0) {
-		rc = access_ok(access, arg, request_offset + request_size);
+		rc = access_ok(access, (void *)arg,
+			       request_offset + request_size);
 
 		if (!rc) {
 			rc = -EFAULT;
-- 
1.7.7.3


