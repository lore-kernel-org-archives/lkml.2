Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab0E1Orz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:47:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40455 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab0E1Orv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:47:51 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=Q5mx56m-u-UA:10 a=VZGMvYHv9TIA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=VC6MDQSm5cczis9e8uwA:9 a=d9QrqFu1GRKIDRG8dLddgSBLWjsA:4 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100528144749.072671097@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 May 2010 10:43:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       Toralf Foerster <toralf.foerster@gmx.de>
Subject: [PATCH 1/3] [PATCH 1/3] kconfig: Make a variable local in streamline_config.pl
References: <20100528144323.232583082@goodmis.org>
Content-Disposition: inline; filename=0001-kconfig-Make-a-variable-local-in-streamline_config.p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toralf Foerster <toralf.foerster@gmx.de>

Proper perl requires that local variables should be declared with 'my',
otherwise this may produce errors.

Signed-off-by: Toralf Foerster <toralf.foerster@gmx.de>
LKML-Reference: <201005281025.00358.toralf.foerster@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index afbd54a..9726946 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -307,7 +307,7 @@ close (LIN);
 my %configs;
 foreach my $module (keys(%modules)) {
     if (defined($objects{$module})) {
-	@arr = @{$objects{$module}};
+	my @arr = @{$objects{$module}};
 	foreach my $conf (@arr) {
 	    $configs{$conf} = $module;
 	}
-- 
1.7.0


