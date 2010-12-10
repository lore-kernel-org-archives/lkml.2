Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0LJLnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:43:41 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:13798
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430Ab0LJLni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:43:38 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzz8275bh8275dh8275chz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LD7N8H-02-2MN-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/2] oprofile, x86: updates for AMD family 15h systems
Date: Fri, 10 Dec 2010 12:29:56 +0100
Message-ID: <1291980598-21625-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for AMD family 15h systems. It adds cpu
detection code for family 15h and implements support for 6 counters.

Suravee already sent updates for the oprofile userland to the oprofile
mailing list.

Please review. If the patches are fine I will apply them to the
oprofile git repostitory on kernel.org.

Thanks,

-Robert
>From robert.richter@amd.com Fri Dec 10 12:29:57 2010 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, oprofile-list <oprofile-list@lists.sourceforge.net>, Robert Richter <robert.richter@amd.com>
Bcc: osrc-patches@elbe.amd.com
Subject: [PATCH 1/2] oprofile, x86: Add support for AMD family 15h
Date: Fri, 10 Dec 2010 12:29:57 +0100
Message-Id: <1291980598-21625-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291980598-21625-1-git-send-email-robert.richter@amd.com>
References: <1291980598-21625-1-git-send-email-robert.richter@amd.com>

This patch adds support for AMD family 15h (Interlagos/Valencia/
Zambezi) cpus.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 4e8baad..358c8b9 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -732,6 +732,9 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		case 0x14:
 			cpu_type = "x86-64/family14h";
 			break;
+		case 0x15:
+			cpu_type = "x86-64/family15h";
+			break;
 		default:
 			return -ENODEV;
 		}
-- 
1.7.3.2


