Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab1HDANr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 20:13:47 -0400
Received: from plexity.net ([206.123.115.38]:52534 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab1HDANl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 20:13:41 -0400
Date: Wed, 3 Aug 2011 17:04:01 -0700
From: Deepak Saxena <dsaxena@linaro.org>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH] Remove CLOCK_TICK_RATE dependency from PAS16 driver
Message-ID: <20110804000401.GB23503@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the PAS16 driver to use PIT_TICK_RATE instead
of the more generic CLOCK_TICK_RATE as the two are
equivalent on X86 and we want to depecrate the later.

Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
---
 sound/oss/pas2_pcm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/oss/pas2_pcm.c b/sound/oss/pas2_pcm.c
index 8f7d175..6f13ab4 100644
--- a/sound/oss/pas2_pcm.c
+++ b/sound/oss/pas2_pcm.c
@@ -63,13 +63,13 @@ static int pcm_set_speed(int arg)
 
 	if (pcm_channels & 2)
 	{
-		foo = ((CLOCK_TICK_RATE / 2) + (arg / 2)) / arg;
-		arg = ((CLOCK_TICK_RATE / 2) + (foo / 2)) / foo;
+		foo = ((PIT_TICK_RATE / 2) + (arg / 2)) / arg;
+		arg = ((PIT_TICK_RATE / 2) + (foo / 2)) / foo;
 	}
 	else
 	{
-		foo = (CLOCK_TICK_RATE + (arg / 2)) / arg;
-		arg = (CLOCK_TICK_RATE + (foo / 2)) / foo;
+		foo = (PIT_TICK_RATE + (arg / 2)) / arg;
+		arg = (PIT_TICK_RATE + (foo / 2)) / foo;
 	}
 
 	pcm_speed = arg;
-- 
1.7.4.1

