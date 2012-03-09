Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab2CIULW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:11:22 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48830 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031297Ab2CITup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:45 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 14:50:44 EST
Message-Id: <20120309190209.767596433@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Danny Kukawka <danny.kukawka@bisect.de>
Subject: [ 93/95] cs5535-mfgpt: dont call __init function from __devinit
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Kukawka <danny.kukawka@bisect.de>

commit 474de3bbadd9cb75ffc32cc759c40d868343d46c upstream.

Fix scan_timers() to be __devinit and not __init since
the function get called from cs5535_mfgpt_probe which is
__devinit.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/cs5535-mfgpt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -262,7 +262,7 @@ static void __init reset_all_timers(void
  * In other cases (such as with VSAless OpenFirmware), the system firmware
  * leaves timers available for us to use.
  */
-static int __init scan_timers(struct cs5535_mfgpt_chip *mfgpt)
+static int __devinit scan_timers(struct cs5535_mfgpt_chip *mfgpt)
 {
 	struct cs5535_mfgpt_timer timer = { .chip = mfgpt };
 	unsigned long flags;


