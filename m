Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1FESDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:03:30 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:46152 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755523Ab1FESDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:03:13 -0400
X-AuditID: 12074422-b7b0eae000007f48-9e-4debc4e42964
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
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Date: Sun,  5 Jun 2011 13:50:25 -0400
Message-Id: <4de62bfbf6974f14d0e9d9ae37cc137dbc926a30.1307292171.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA3WSXUzTUBTHvWvXdQvVUkEuKGqqRoMOMGpyTfwKGm2MU+KLBh+0ssImWyHr
	QPDBoEajqIBGoiEQIBFjEMMcEMAHkDEBFRCRj4WggIwo2xARjPjtKkGffPvf8/+d/8nJPSTG
	DCrDSKNoFSwib2IJDc6og1do3U6vLnrSg1BBRTmBsrsfq5Cz97MK5fdSaMr2k0DtDogefR0l
	0ERPDYFePiwgUO1AN4Hc5/oAquo6p0Qj5W8x9OGajUCV9jwMvckeV6GuiQ84mrGNKHcw3Ofz
	2TjX3NYEuP4L3zGuqG4ScLcvzqi4uvxXKq7ybgT3a8xJcNd8LsDZyy4R3PuODhXXeusbzrW0
	7eSm7Es5R42PiF0Qp9miF0zGNMESte2YxtDqOANShsn0HJ9PkQkaVFlATUJ6I8zOm1bM6kWw
	83UFkQU0JEPXA9hSVAhmHxUAXr8/gMkUQ48q4MOza2RN0CvhxdIhfzdJBtFRsGfqD4/RRUpo
	f3YZl5mF9CHYXDqjlDVOr4JNd2yErCn6IHRcaVTKvZBeDp+XJctlNR0NO/valbOjoqBj/Anx
	v3ouoIvBvDIQrjef0pp5o0kS4rVSPC+KgkW7KdJstEYK+lQ7kP9OtYutBV8aWQegScAGUFXl
	Xh2j5NOkDLMDhJIKNpgqbvKX5h9P1mcYeMlw1JJqEiQHgCTGBlGngzw6htLzGacES/KctZjE
	2RCqIHS1jqETeauQJAgpgmXOXUKSLKQG5dBAi5AopCcYTdZ/toJUy+EB/vAfMkNJKbxZMibO
	+k+BlqxuHW8EDC4mi0JYCOWRIVqGDKni35y5u/SAEP9aC6l2mQrwX+3fJI9/iMI/pCVG3kCy
	8v+ssExw8+wLbzEYyOn+ONxwYyMo67+ekHP1cWwKtzhzs+iadh6+ge9x39vbF5271lm4fXLi
	6ZB4dQ1WGO+TSk4oksbCA8eTNlx6sG46fESjjtPp92V9HTgShMfS+e5QpncE71vWsaMkpovQ
	7zlwy3skD/vkqsb37926u8L1Lr3+ZNvHMywuGfj1EZhF4n8DTvg4uXIDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_UNSAFE_VSYSCALLS was added in the previous patch as a
temporary hack to avoid penalizing users who don't build glibc from
git.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 1a9446b..94b4470 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -600,3 +600,12 @@ Why:	Superseded by the UVCIOC_CTRL_QUERY ioctl.
 Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 
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
1.7.5.2

