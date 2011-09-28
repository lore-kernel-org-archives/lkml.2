Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1I1HD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:03:58 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46909 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1I1HD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:03:57 -0400
Date: Wed, 28 Sep 2011 17:03:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>, Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the moduleh tree with the sound tree
Message-Id: <20110928170349.bf96e9f99c989c0d5190d2fc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
sound/soc/soc-io.c between commit be3ea3b9e8df ("ASoC: Use new register
map API for ASoC generic physical I/O") from the sound tree and commit
1aff9ab90466 ("sound: Add export.h for THIS_MODULE/EXPORT_SYMBOL where
needed") from the moduleh tree.

I fixed it up (see below) and can carry the fix as necessary.

[Mark Brown <broonie@opensource.wolfsonmicro.com> was left off the cc list
because his host is not reolving in the DNS currently.]
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/soc-io.c
index 66fcccd,963efe0..0000000
--- a/sound/soc/soc-io.c
+++ b/sound/soc/soc-io.c
@@@ -13,7 -13,7 +13,8 @@@
  
  #include <linux/i2c.h>
  #include <linux/spi/spi.h>
 +#include <linux/regmap.h>
+ #include <linux/export.h>
  #include <sound/soc.h>
  
  #include <trace/events/asoc.h>
