Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1BDRtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:49:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1BDRtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:49:12 -0500
Date: Fri, 4 Feb 2011 12:48:39 -0500
From: John Villalovos <jvillalo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "John L. Villalovos" <john.l.villalovos@intel.com>, prarit@redhat.com
Subject: [PATCH 1/1] x86, apic: Make "broken BIOS!!" messages unique
Message-ID: <20110204174831.GA10370@intel-s3eb1-02.lab.bos.redhat.com>
Reply-To: John Villalovos <jvillalo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86, apic: Make "broken BIOS!!" messages unique

There are five identical "broken BIOS!!" messages.  This patch makes each
message unique so that it is easier to determine which message was actually
printed.

The 'inconceivable' messages are because it should not be possible to reach
those code paths.

Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 697dc34..b0c40c3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -841,7 +841,7 @@ static int MPBIOS_polarity(int idx)
 		}
 		case 2: /* reserved */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING "broken BIOS: polarity!!\n");
 			polarity = 1;
 			break;
 		}
@@ -852,7 +852,7 @@ static int MPBIOS_polarity(int idx)
 		}
 		default: /* invalid */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING "broken BIOS: inconceivable polarity!!\n");
 			polarity = 1;
 			break;
 		}
@@ -899,7 +899,7 @@ static int MPBIOS_trigger(int idx)
 				}
 				default:
 				{
-					printk(KERN_WARNING "broken BIOS!!\n");
+					printk(KERN_WARNING "broken BIOS: unknown bus type!!\n");
 					trigger = 1;
 					break;
 				}
@@ -913,7 +913,7 @@ static int MPBIOS_trigger(int idx)
 		}
 		case 2: /* reserved */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING "broken BIOS: trigger!!\n");
 			trigger = 1;
 			break;
 		}
@@ -924,7 +924,7 @@ static int MPBIOS_trigger(int idx)
 		}
 		default: /* invalid */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING "broken BIOS: inconceivable trigger!!\n");
 			trigger = 0;
 			break;
 		}
