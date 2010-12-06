Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0LFAfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 19:35:48 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57841 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab0LFAfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 19:35:47 -0500
Date: Mon, 6 Dec 2010 11:35:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the sound tree with the Linus' tree
Message-Id: <20101206113542.b1d2f978.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
sound/soc/sh/fsi.c between commit
d4bc99b977e3a1dd10a84a01ebe59ac2ccebf0cd ("ARM: mach-shmobile: ap4evb:
FSI clock use proper process for HDMI") from Linus' tree and commit
2b0e73025f74699e9cc9df60649fcc14cd02481b ("ASoC: sh: fsi: change
fsi->mst_ctrl to master->a/b_mclk") from the sound tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/sh/fsi.c
index 4c2404b,19a2f99..0000000
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@@ -131,10 -142,6 +142,8 @@@ struct fsi_priv 
  
  	struct fsi_stream playback;
  	struct fsi_stream capture;
 +
 +	long rate;
- 
- 	u32 mst_ctrl;
  };
  
  struct fsi_core {
