Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1EaNRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:17:36 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:57253 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720Ab1EaNR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:17:28 -0400
X-AuditID: 12074425-b7b78ae000007e02-c0-4de4ea5544ed
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Date: Tue, 31 May 2011 09:16:04 -0400
Message-Id: <7e604b2dd699a30204fda3d1011f3af5a2c56572.1306847455.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsUixCmqrRv66omvwdEDnBZz1q9hs+i7cpTd
	4si17+wWs67xWnze8I/N4sCvp2wW769uZ7O4vGsOm8WT5uuMFlsuNbNafJi4gc1i86apzBaP
	+t6yW/zY8JjVgc/je2sfi8exM4cZPW61/WH2mL/zI6PHzll32T02r9Dy+P/yCJvHplWdbB7v
	zp1j9zgx4zeLx/Ezzh6fN8kF8ERx2aSk5mSWpRbp2yVwZbz7fY694DZ7xcSNCxgbGM+ydTFy
	ckgImEhsmPGPEcIWk7hwbz1QnItDSGAfo8S5jb/ZIZwNjBJnGyYyQjjPmCQe3t3IAtLCJqAi
	0bH0AVMXIweHiIC+xNXPYDXMApNYJA7/PQ1WIywQKXF70l5WEJtFQFVi15fJ7CA2r0CQxPV9
	79ghVitIXLkyD6yeU8BAonnlGrDzhIBm3n9yhRmX+ARGgQWMDKsYZVNyq3RzEzNzilOTdYuT
	E/PyUot0LfRyM0v0UlNKNzGC4obdRXUH44RDSocYBTgYlXh42w8+9hViTSwrrsw9xCjJwaQk
	ynv25RNfIb6k/JTKjMTijPii0pzU4kOMEhzMSiK83/iAcrwpiZVVqUX5MClpDhYlcd75kuq+
	QgLpiSWp2ampBalFMFkZDg4lCd4ZIEMFi1LTUyvSMnNKENJMHJwgw3mAhp8EqeEtLkjMLc5M
	h8ifYtTlaFy74yCjEEtefl6qlDhvFkiRAEhRRmke3BxYunvFKA70ljBvP0gVDzBVwk16BbSE
	CWhJ77uHIEtKEhFSUg2MS+IfFC0pimXZNifvmCX7LV+x6+0TPgtteX4sa1/jizlcd3vn7z4U
	/H3+59fBdqIsm7e7fFe1TOs6s+72jkvB+Z6fJE4k7s1f8vvOzQcWd2Il37yLLT+/KaXK/+OV
	ecdOMXTu32omdsSpddsffVVJla8M6VsvcbmZ/XG9q9/9N+rCIa2UjUHv2ZRYijMSDbWYi4oT
	AYXfCFZSAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 492e81d..db7a122 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -580,3 +580,12 @@ Why:	These legacy callbacks should no longer be used as i2c-core offers
 Who:	Jean Delvare <khali@linux-fr.org>
 
 ----------------------------
+
+What:	CONFIG_UNSAFE_VSYSCALLS (x86_64)
+When:	When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
+Why:	Having user-executable code at a fixed address is a security problem.
+	Turning off CONFIG_UNSAFE_VSYSCALLS mostly removes the risk but will
+	make the time() function slower on glibc versions 2.13 and below.
+Who:	Andy Lutomirski <luto@mit.edu>
+
+----------------------------
-- 
1.7.5.1

