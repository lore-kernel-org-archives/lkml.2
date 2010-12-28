Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0L1UiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:38:24 -0500
Received: from smtp-out-091.synserver.de ([212.40.180.91]:1035 "HELO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752111Ab0L1UiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:38:21 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 9841
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/9 v2] ASoC: codecs: Fix register cache incoherencies
Date: Tue, 28 Dec 2010 21:37:54 +0100
Message-Id: <1293568684-9626-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multi-component patch(commit f0fba2ad1) moved the allocation of the
register cache from the driver to the ASoC core. Most drivers where adjusted to
this, but there are also some drivers now which use a mixture of their own
register cache and the generic register cache.
Thus these end up with two from each other incoherent register caches, which can
lead to undefined behaviour.
This patch series tries to fix these drivers by converting them to always use
the generic register cache framework instead of their own.

There are also quite a few drivers left, which do not use their own register
cache anymore, but still have a field for it in their private device structure.
The first patch of this series addresses those drivers and removes the unused
register cache arrays from their private device structs.

Please note, these patches, with the exception of wm8753, were only compile
tested.

Changes since v1:
	* rebased against 2.6.37-rc7
	* correct commit message
	* more straight forward conversion in the wm8753 patch (there will be a
	  followup patch for cleanps)

- Lars

Lars-Peter Clausen (9):
  ASoC: codecs: Remove unused reg_cache fields from device structs
  ASoC: codecs: max98088: Fix register cache incoherency
  ASoC: codecs: wm8523: Fix register cache incoherency
  ASoC: codecs: wm8741: Fix register cache incoherency
  ASoC: codecs: wm8904: Fix register cache incoherency
  ASoC: codecs: wm8955: Fix register cache incoherency
  ASoC: codecs: wm8962: Fix register cache incoherency
  ASoC: codecs: wm9090: Fix register cache incoherency
  ASoC: codecs: wm8753: Fix register cache incoherency

 sound/soc/codecs/88pm860x-codec.c |    1 -
 sound/soc/codecs/ad193x.c         |    1 -
 sound/soc/codecs/ak4671.c         |    1 -
 sound/soc/codecs/cs4270.c         |    1 -
 sound/soc/codecs/cs42l51.c        |    1 -
 sound/soc/codecs/cx20442.c        |    1 -
 sound/soc/codecs/max98088.c       |   13 +-
 sound/soc/codecs/tlv320aic26.c    |    4 +-
 sound/soc/codecs/uda1380.c        |    1 -
 sound/soc/codecs/wm8523.c         |    9 +-
 sound/soc/codecs/wm8580.c         |    1 -
 sound/soc/codecs/wm8711.c         |    1 -
 sound/soc/codecs/wm8731.c         |    1 -
 sound/soc/codecs/wm8741.c         |   10 +-
 sound/soc/codecs/wm8750.c         |    1 -
 sound/soc/codecs/wm8753.c         |  267 ++++++++++++++-----------------------
 sound/soc/codecs/wm8900.c         |    1 -
 sound/soc/codecs/wm8903.c         |    2 -
 sound/soc/codecs/wm8904.c         |   37 +++---
 sound/soc/codecs/wm8940.c         |    1 -
 sound/soc/codecs/wm8955.c         |   30 ++--
 sound/soc/codecs/wm8960.c         |    1 -
 sound/soc/codecs/wm8961.c         |    1 -
 sound/soc/codecs/wm8962.c         |   45 +++----
 sound/soc/codecs/wm8974.c         |    1 -
 sound/soc/codecs/wm8978.c         |    1 -
 sound/soc/codecs/wm8988.c         |    1 -
 sound/soc/codecs/wm8993.c         |    1 -
 sound/soc/codecs/wm9081.c         |    1 -
 sound/soc/codecs/wm9090.c         |   18 ++--
 30 files changed, 179 insertions(+), 276 deletions(-)

-- 
1.7.2.3

