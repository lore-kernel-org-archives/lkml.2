Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440Ab2EJReY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:34:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52483 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760409Ab2EJReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:19 -0400
Message-Id: <20120510173134.595937051@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 19/52] regulator: Fix the logic to ensure new voltage setting in valid range
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit f55205f4d4a8823a11bb8b37ef2ecbd78fb09463 upstream.

I think this is a typo.
To ensure new voltage setting won't greater than desc->max,
the equation should be desc->min + desc->step * new_val <= desc->max.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/max8997.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -689,7 +689,7 @@ static int max8997_set_voltage_buck(stru
 		}
 
 		new_val++;
-	} while (desc->min + desc->step + new_val <= desc->max);
+	} while (desc->min + desc->step * new_val <= desc->max);
 
 	new_idx = tmp_idx;
 	new_val = tmp_val;


