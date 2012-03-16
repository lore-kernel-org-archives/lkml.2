Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946188Ab2CPXjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:39:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162096Ab2CPXjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:01 -0400
Message-Id: <20120316233449.765980127@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 28/38] regulator: Fix setting selector in tps6524x set_voltage function
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit f03570cf1709397ebe656608266b44ec772960c2 upstream.

Don't assign the voltage to selector.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/tps6524x-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -481,7 +481,7 @@ static int set_voltage(struct regulator_
 	if (i >= info->n_voltages)
 		i = info->n_voltages - 1;
 
-	*selector = info->voltages[i];
+	*selector = i;
 
 	return write_field(hw, &info->voltage, i);
 }


