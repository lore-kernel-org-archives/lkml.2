Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab1KBC1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:27:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38809 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754439Ab1KBC1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:27:42 -0400
Message-ID: <1320200857.15779.4.camel@Joe-Laptop>
Subject: [PATCH] checkpatch: Prefer __printf not
 __attribute__((format(printf,...)))
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Wed, 02 Nov 2011 04:27:37 +0200
In-Reply-To: <20111101150908.b482fad5.akpm@linux-foundation.org>
References: <5a0bef0143ed2b3176917fdc0ddd6a47f4c79391.1314303846.git.joe@perches.com>
	 <20110825165006.af771ef7.akpm@linux-foundation.org>
	 <1314316801.19476.6.camel@Joe-Laptop>
	 <20110825170534.0d425c75.akpm@linux-foundation.org>
	 <1314319088.19476.17.camel@Joe-Laptop>
	 <20110825180734.9beae279.akpm@linux-foundation.org>
	 <1314327338.19476.30.camel@Joe-Laptop>
	 <20111101150908.b482fad5.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a warn for not using __printf.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Tue, 2011-11-01 at 15:09 -0700, Andrew Morton wrote:
> hm, we don't appear to have a checkpatch rule telling people not to use
> __attribute__((format(printf, ...))).  Who should I hassle about that? :)

Probably Andy Whitcroft.  Until he reappears though...

 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5e93342..6cae370 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3097,6 +3097,12 @@ sub process {
 			     "__aligned(size) is preferred over __attribute__((aligned(size)))\n" . $herecurr);
 		}
 
+# Check for __attribute__ format(printf, prefer __printf
+		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf/) {
+			WARN("PREFER_PRINTF",
+			     "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("SIZEOF_ADDRESS",


