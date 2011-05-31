Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1EaOP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:15:28 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:51501 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405Ab1EaOPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:15:25 -0400
X-AuditID: 1209190c-b7c65ae00000117c-ec-4de4f804d3a7
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
Subject: [PATCH v4 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Date: Tue, 31 May 2011 10:14:08 -0400
Message-Id: <1660d1687db01852ec58bbf970e22868db367d53.1306851090.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsUixG6nosvy44mvwclFChZz1q9hs+i7cpTd
	4si17+wWs67xWnze8I/N4sCvp2wW769uZ7O4vGsOm8WT5uuMFlsuNbNafJi4gc1i86apzBaP
	+t6yW/zY8JjVgc/je2sfi8exM4cZPW61/WH2mL/zI6PHzll32T02r9Dy+P/yCJvHplWdbB7v
	zp1j9zgx4zeLx/Ezzh6fN8kF8ERx2aSk5mSWpRbp2yVwZcz5tIml4Bp7xec/D1gaGM+xdTFy
	cEgImEi8m5TXxcgJZIpJXLi3ng3EFhLYxyjxYDZvFyMXkL2BUeLWqq3sEM4zJomdSx+CVbEJ
	qEh0LH3ABDJIREBf4upnRpAaZoFJLBKH/55mAakRFoiUOPFhHlgNi4CqROM5IZAwr0CQxK7X
	39khFitIXLkyD6ycU8BAYvvVVYwg5UJAI49/0MUhPIFRYAEjwypG2ZTcKt3cxMyc4tRk3eLk
	xLy81CJdQ73czBK91JTSTYygaOGU5NnB+Oag0iFGAQ5GJR7exIOPfYVYE8uKK3MPMUpyMCmJ
	8lZ8e+IrxJeUn1KZkVicEV9UmpNafIhRgoNZSYT3Gx9QjjclsbIqtSgfJiXNwaIkzjtDUt1X
	SCA9sSQ1OzW1ILUIJivDwaEkwWv0HahRsCg1PbUiLTOnBCHNxMEJMpwHaHghyGLe4oLE3OLM
	dIj8KUZdjsa1Ow4yCrHk5eelSonzWoEMEgApyijNg5sDS3KvGMWB3hLmVQCp4gEmSLhJr4CW
	MAEt6X33EGRJSSJCSqqBcerWgs/TBEN+9OyRvmVR4rlwbVXJZbvT97KuCWlMyU28eb9Vannk
	Ii7WBuOK7qTLH3fP8N22k+3dzG3f/m75Kuyws80vVZj1ZsbvPxvuzzc84SIjYdq6ybCjb2r9
	2rT2qKmcDUy1fpVX5//wPn5Q4iv3iard/jHv3ytGpFuu0Hxy9aeQrsv7QiWW4oxEQy3mouJE
	AJkRExhNAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.7.5.1

