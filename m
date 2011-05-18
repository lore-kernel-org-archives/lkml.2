Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab1ERPGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:06:08 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57627 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933151Ab1ERPGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:06:07 -0400
X-IronPort-AV: E=Sophos;i="4.65,231,1304287200"; 
   d="scan'208";a="94943775"
Date: Wed, 18 May 2011 17:06:05 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: James.Bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        akpm@linux-foundation.org
Subject: [PATCH]: Fix Ultrastor asm snippet
Message-ID: <20110518150605.GA25262@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1292500b replaced

"=m" (*field) : "1" (*field)

with

"=m" (*field) :

with comment "The following patch fixes it by using the '+' operator on
the (*field) operand, marking it as read-write to gcc."
'+' was actually forgotten.  This really puts it.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 0571ef9..dc076e0 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -306,7 +306,7 @@ static inline int find_and_clear_bit_16(unsigned long *field)
 	"0: bsfw %1,%w0\n\t"
 	"btr %0,%1\n\t"
 	"jnc 0b"
-	: "=&r" (rv), "=m" (*field) :);
+	: "=&r" (rv), "+m" (*field) :);
 
   return rv;
 }
