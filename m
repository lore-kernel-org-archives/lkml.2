Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab0KXTq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:46:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59516 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab0KXTqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:46:24 -0500
Date: Wed, 24 Nov 2010 11:46:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Harsha Priya <priya.harsha@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dharageswari R <dharageswari.r@intel.com>,
        KP Jeeja <jeeja.kp@intel.com>
Subject: [PATCH -next] staging: fix intel_sst/intelmid sound build
Message-Id: <20101124114609.2b6e030e.randy.dunlap@oracle.com>
In-Reply-To: <20101124131047.b738bc7c.sfr@canb.auug.org.au>
References: <20101124131047.b738bc7c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

SND_INTELMID selects 3 SND_* kconfig symbols, but that is useless
if the SOUND & SND symbols in their hierarchy are not enabled,
so make this symbol depend on SOUND & SND.

ERROR: "snd_pcm_period_elapsed" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_card_create" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_pcm_hw_constraint_integer" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_device_new" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_pcm_set_ops" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_jack_new" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_pcm_lib_free_pages" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_pcm_lib_ioctl" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_pcm_lib_malloc_pages" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_ctl_new1" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_pcm_lib_preallocate_pages_for_all" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_card_free" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_card_register" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_jack_report" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_pcm_new" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!
ERROR: "snd_ctl_add" [drivers/staging/intel_sst/snd-intelmid.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/intel_sst/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101124.orig/drivers/staging/intel_sst/Kconfig
+++ linux-next-20101124/drivers/staging/intel_sst/Kconfig
@@ -8,6 +8,7 @@ config SND_INTEL_SST
 
 config SND_INTELMID
 	tristate "Intel MID sound card driver"
+	depends on SOUND && SND
 	select SND_PCM
 	select SND_SEQUENCER
 	select SND_JACK
