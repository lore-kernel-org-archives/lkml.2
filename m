Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407Ab0G3Req (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:34:46 -0400
Received: from kroah.org ([198.145.64.141]:35492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759264Ab0G3ReB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:01 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:04 2010
Message-Id: <20100730173104.040368201@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rudolf Marek <r.marek@assembler.cz>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [014/140] hwmon: (k8temp) Fix temperature reporting for ASB1 processor revisions
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit d535bad90dad4eb42ec6528043fcfb53627d4f89 upstream.

Reported temperature for ASB1 CPUs is too high.
Add ASB1 CPU revisions (these are also non-desktop variants) to the
list of CPUs for which the temperature fixup is not required.

Example: (from LENOVO ThinkPad Edge 13, 01972NG, system was idle)

  Current kernel reports

  $ sensors
  k8temp-pci-00c3
  Adapter: PCI adapter
  Core0 Temp:  +74.0 C
  Core0 Temp:  +70.0 C
  Core1 Temp:  +69.0 C
  Core1 Temp:  +70.0 C

  With this patch I have

  $ sensors
  k8temp-pci-00c3
  Adapter: PCI adapter
  Core0 Temp:  +54.0 C
  Core0 Temp:  +51.0 C
  Core1 Temp:  +48.0 C
  Core1 Temp:  +49.0 C

Cc: Rudolf Marek <r.marek@assembler.cz>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/k8temp.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -180,11 +180,13 @@ static int __devinit k8temp_probe(struct
 		}
 
 		if ((model >= 0x69) &&
-		    !(model == 0xc1 || model == 0x6c || model == 0x7c)) {
+		    !(model == 0xc1 || model == 0x6c || model == 0x7c ||
+		      model == 0x6b || model == 0x6f || model == 0x7f)) {
 			/*
-			 * RevG desktop CPUs (i.e. no socket S1G1 parts)
-			 * need additional offset, otherwise reported
-			 * temperature is below ambient temperature
+			 * RevG desktop CPUs (i.e. no socket S1G1 or
+			 * ASB1 parts) need additional offset,
+			 * otherwise reported temperature is below
+			 * ambient temperature
 			 */
 			data->temp_offset = 21000;
 		}


