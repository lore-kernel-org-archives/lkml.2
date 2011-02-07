Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1BGP2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:28:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:51305 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1BGP2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:28:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="385195083"
Date: Mon, 7 Feb 2011 05:58:43 -0800
From: John Villalovos <john.l.villalovos@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, John Villalovos <jvillalo@redhat.com>,
        prarit@redhat.com
Subject: [PATCH 1/1 V2] x86, apic: Make "broken BIOS!!" messages unique
Message-ID: <20110207135843.GA10121@linuxjohn3.jf.intel.com>
Reply-To: John Villalovos <john.l.villalovos@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86, apic: Make "broken BIOS!!" messages unique

There are five identical "broken BIOS!!" messages.  This patch makes each
message unique so that it is easier to determine which message was actually
printed.  Changed to "broken MPBIOS: <unique identifier>!!"

The 'inconceivable' messages are because it should not be possible to reach
those code paths.

V2: Change to specify MPBIOS and remove exclamation marks.

Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 697dc34..5391276 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -841,7 +841,7 @@ static int MPBIOS_polarity(int idx)
 		}
 		case 2: /* reserved */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING "broken MPBIOS: polarity\n");
 			polarity = 1;
 			break;
 		}
@@ -852,7 +852,7 @@ static int MPBIOS_polarity(int idx)
 		}
 		default: /* invalid */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING "broken MPBIOS: inconceivable polarity\n");
 			polarity = 1;
 			break;
 		}
@@ -899,7 +899,7 @@ static int MPBIOS_trigger(int idx)
 				}
 				default:
 				{
-					printk(KERN_WARNING "broken BIOS!!\n");
+					printk(KERN_WARNING "broken MPBIOS: unknown bus type\n");
 					trigger = 1;
 					break;
 				}
@@ -913,7 +913,7 @@ static int MPBIOS_trigger(int idx)
 		}
 		case 2: /* reserved */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING "broken MPBIOS: trigger\n");
 			trigger = 1;
 			break;
 		}
@@ -924,7 +924,7 @@ static int MPBIOS_trigger(int idx)
 		}
 		default: /* invalid */
 		{
-			printk(KERN_WARNING "broken BIOS!!\n");
+			printk(KERN_WARNING "broken MPBIOS: inconceivable trigger\n");
 			trigger = 0;
 			break;
 		}
