Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2CLMsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:48:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab2CLMsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:48:40 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Some fixes over the last EDAC series
Date: Mon, 12 Mar 2012 09:48:31 -0300
Message-Id: <1331556515-7902-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains a few bug fixes/regressions introduced by
my patch series.

There are two trivial bug fixes for i5100/i3200 drivers. It also contains
a bug fix for amd64_edac, as commented at the ML.

The bigger patch here is the one that will print "rank" instead of "dimm"
for the debug messages. This patch complements the patch 5/6 of the previous
series [1], as discussed.

[1] http://lkml.org/lkml/2012/3/7/174

I may fold those patches when submitting my git tree to Linus, but
it is better to keep them as incremental patches for the reviewers to
not need to review the entire patch series again.

The tree with this patches (and the previous ones) is available (after
kernel.org mirror sync) at:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v7

Mauro Carvalho Chehab (4):
  i3200_edac: Fix a regression introduced by 3b6909b
  edac: display "rank" for csrow-based MC's at the debug msgs
  amd64_edac: Fix the rank number of pages count
  i5100_edac: Fix a warning on a debug message

 drivers/edac/amd64_edac.c    |    2 +-
 drivers/edac/edac_mc.c       |   43 +++++++++++++++++++++++++++++------------
 drivers/edac/edac_mc_sysfs.c |   19 ++++-------------
 drivers/edac/i3200_edac.c    |    3 +-
 drivers/edac/i5100_edac.c    |    2 +-
 include/linux/edac.h         |   12 ++++++++++-
 6 files changed, 50 insertions(+), 31 deletions(-)

The amd64_edac driver is now properly reporting the memory ranks on
my test system (a 8 sockets/32 core system, equipped with 4 x 4GB 1R DIMMs):

# grep . /sys/devices/system/edac/mc/mc?/dimm*/* /sys/devices/system/edac/mc/mc?/rank*/*
grep: /sys/devices/system/edac/mc/mc?/dimm*/*: Arquivo ou diretório não encontrado
/sys/devices/system/edac/mc/mc0/rank4/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc0/rank4/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc0/rank4/dimm_label:mc#0csrow#4channel#0
/sys/devices/system/edac/mc/mc0/rank4/dimm_location:csrow 4 channel 0 
/sys/devices/system/edac/mc/mc0/rank4/dimm_mem_type:Registered-DDR3
/sys/devices/system/edac/mc/mc0/rank4/dimm_size:4096
/sys/devices/system/edac/mc/mc2/rank4/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc2/rank4/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc2/rank4/dimm_label:mc#2csrow#4channel#0
/sys/devices/system/edac/mc/mc2/rank4/dimm_location:csrow 4 channel 0 
/sys/devices/system/edac/mc/mc2/rank4/dimm_mem_type:Registered-DDR3
/sys/devices/system/edac/mc/mc2/rank4/dimm_size:4096
/sys/devices/system/edac/mc/mc4/rank4/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc4/rank4/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc4/rank4/dimm_label:mc#4csrow#4channel#0
/sys/devices/system/edac/mc/mc4/rank4/dimm_location:csrow 4 channel 0 
/sys/devices/system/edac/mc/mc4/rank4/dimm_mem_type:Registered-DDR3
/sys/devices/system/edac/mc/mc4/rank4/dimm_size:4096
/sys/devices/system/edac/mc/mc7/rank4/dimm_dev_type:Unknown
/sys/devices/system/edac/mc/mc7/rank4/dimm_edac_mode:S4ECD4ED
/sys/devices/system/edac/mc/mc7/rank4/dimm_label:mc#7csrow#4channel#0
/sys/devices/system/edac/mc/mc7/rank4/dimm_location:csrow 4 channel 0 
/sys/devices/system/edac/mc/mc7/rank4/dimm_mem_type:Registered-DDR3
/sys/devices/system/edac/mc/mc7/rank4/dimm_size:4096

# dmesg|grep -i edac|grep MC:
[   37.462195] EDAC MC: Ver: 2.1.0
[   37.610622] EDAC MC: DCT0 chip selects:
[   37.610624] EDAC amd64: MC: 0:     0MB 1:     0MB
[   37.667756] EDAC amd64: MC: 2:     0MB 3:     0MB
[   37.700294] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   37.732300] EDAC amd64: MC: 6:     0MB 7:     0MB
[   37.763833] EDAC MC: DCT1 chip selects:
[   37.763838] EDAC amd64: MC: 0:     0MB 1:     0MB
[   37.794506] EDAC amd64: MC: 2:     0MB 3:     0MB
[   37.862682] EDAC amd64: MC: 4:     0MB 5:     0MB
[   37.949646] EDAC amd64: MC: 6:     0MB 7:     0MB
[   38.624781] EDAC MC: DCT0 chip selects:
[   38.624782] EDAC amd64: MC: 0:     0MB 1:     0MB
[   38.656778] EDAC amd64: MC: 2:     0MB 3:     0MB
[   38.738786] EDAC amd64: MC: 4:     0MB 5:     0MB
[   38.773151] EDAC amd64: MC: 6:     0MB 7:     0MB
[   38.806202] EDAC MC: DCT1 chip selects:
[   38.806203] EDAC amd64: MC: 0:     0MB 1:     0MB
[   38.837650] EDAC amd64: MC: 2:     0MB 3:     0MB
[   38.869205] EDAC amd64: MC: 4:     0MB 5:     0MB
[   38.901188] EDAC amd64: MC: 6:     0MB 7:     0MB
[   39.865634] EDAC MC: DCT0 chip selects:
[   39.865639] EDAC amd64: MC: 0:     0MB 1:     0MB
[   39.897631] EDAC amd64: MC: 2:     0MB 3:     0MB
[   39.930204] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   40.140835] EDAC amd64: MC: 6:     0MB 7:     0MB
[   40.140839] EDAC MC: DCT1 chip selects:
[   40.140841] EDAC amd64: MC: 0:     0MB 1:     0MB
[   40.140842] EDAC amd64: MC: 2:     0MB 3:     0MB
[   40.140844] EDAC amd64: MC: 4:     0MB 5:     0MB
[   40.140847] EDAC amd64: MC: 6:     0MB 7:     0MB
[   41.090571] EDAC MC: DCT0 chip selects:
[   41.090573] EDAC amd64: MC: 0:     0MB 1:     0MB
[   41.123284] EDAC amd64: MC: 2:     0MB 3:     0MB
[   41.154824] EDAC amd64: MC: 4:     0MB 5:     0MB
[   41.184975] EDAC amd64: MC: 6:     0MB 7:     0MB
[   41.215036] EDAC MC: DCT1 chip selects:
[   41.215038] EDAC amd64: MC: 0:     0MB 1:     0MB
[   41.246632] EDAC amd64: MC: 2:     0MB 3:     0MB
[   41.308208] EDAC amd64: MC: 4:     0MB 5:     0MB
[   41.399933] EDAC amd64: MC: 6:     0MB 7:     0MB
[   41.965913] EDAC MC: DCT0 chip selects:
[   41.965918] EDAC amd64: MC: 0:     0MB 1:     0MB
[   42.054599] EDAC amd64: MC: 2:     0MB 3:     0MB
[   42.129714] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   42.163109] EDAC amd64: MC: 6:     0MB 7:     0MB
[   42.194608] EDAC MC: DCT1 chip selects:
[   42.194610] EDAC amd64: MC: 0:     0MB 1:     0MB
[   42.226118] EDAC amd64: MC: 2:     0MB 3:     0MB
[   42.226119] EDAC amd64: MC: 4:     0MB 5:     0MB
[   42.226121] EDAC amd64: MC: 6:     0MB 7:     0MB
[   42.610838] EDAC MC: DCT0 chip selects:
[   42.610843] EDAC amd64: MC: 0:     0MB 1:     0MB
[   42.709570] EDAC amd64: MC: 2:     0MB 3:     0MB
[   42.789579] EDAC amd64: MC: 4:     0MB 5:     0MB
[   42.881698] EDAC amd64: MC: 6:     0MB 7:     0MB
[   42.963611] EDAC MC: DCT1 chip selects:
[   42.963613] EDAC amd64: MC: 0:     0MB 1:     0MB
[   43.043573] EDAC amd64: MC: 2:     0MB 3:     0MB
[   43.128559] EDAC amd64: MC: 4:     0MB 5:     0MB
[   43.199141] EDAC amd64: MC: 6:     0MB 7:     0MB
[   43.519255] EDAC MC: DCT0 chip selects:
[   43.519257] EDAC amd64: MC: 0:     0MB 1:     0MB
[   43.550192] EDAC amd64: MC: 2:     0MB 3:     0MB
[   43.582120] EDAC amd64: MC: 4:     0MB 5:     0MB
[   43.613620] EDAC amd64: MC: 6:     0MB 7:     0MB
[   43.658514] EDAC MC: DCT1 chip selects:
[   43.658516] EDAC amd64: MC: 0:     0MB 1:     0MB
[   43.761584] EDAC amd64: MC: 2:     0MB 3:     0MB
[   43.850554] EDAC amd64: MC: 4:     0MB 5:     0MB
[   43.937551] EDAC amd64: MC: 6:     0MB 7:     0MB
[   44.486332] EDAC MC: DCT0 chip selects:
[   44.486337] EDAC amd64: MC: 0:     0MB 1:     0MB
[   44.540205] EDAC amd64: MC: 2:     0MB 3:     0MB
[   44.571106] EDAC amd64: MC: 4:  4096MB 5:     0MB
[   44.602915] EDAC amd64: MC: 6:     0MB 7:     0MB
[   44.602927] EDAC MC: DCT1 chip selects:
[   44.602931] EDAC amd64: MC: 0:     0MB 1:     0MB
[   44.602935] EDAC amd64: MC: 2:     0MB 3:     0MB
[   44.602939] EDAC amd64: MC: 4:     0MB 5:     0MB
[   44.602944] EDAC amd64: MC: 6:     0MB 7:     0MB

# dmesg|grep -i edac|grep rank
[   38.199552] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc(): allocating 5672 bytes for mci data (8 ranks, 8 csrows/channels)
[   38.199568] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
[   38.199573] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: rank1 (1:0:0): row 1, chan 0
[   38.199576] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: rank2 (2:0:0): row 2, chan 0
[   38.199579] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: rank3 (3:0:0): row 3, chan 0
[   38.199582] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: rank4 (4:0:0): row 4, chan 0
[   38.199585] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: rank5 (5:0:0): row 5, chan 0
[   38.199588] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: rank6 (6:0:0): row 6, chan 0
[   38.199591] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: rank7 (7:0:0): row 7, chan 0
[   39.038966] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc(): allocating 4392 bytes for mci data (8 ranks, 8 csrows/channels)
[   39.038981] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
[   39.038984] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: rank0 (1:0:0): row 1, chan 0
[   39.038987] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: rank0 (2:0:0): row 2, chan 0
[   39.038991] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: rank0 (3:0:0): row 3, chan 0
[   39.038994] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: rank0 (4:0:0): row 4, chan 0
[   39.038997] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: rank0 (5:0:0): row 5, chan 0
[   39.039000] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: rank0 (6:0:0): row 6, chan 0
[   39.039023] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: rank0 (7:0:0): row 7, chan 0
[   40.140865] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc(): allocating 5672 bytes for mci data (8 ranks, 8 csrows/channels)
[   40.140877] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
[   40.140881] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: rank1 (1:0:0): row 1, chan 0
[   40.140884] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: rank2 (2:0:0): row 2, chan 0
[   40.140887] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: rank3 (3:0:0): row 3, chan 0
[   40.140890] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: rank4 (4:0:0): row 4, chan 0
[   40.140893] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: rank5 (5:0:0): row 5, chan 0
[   40.140896] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: rank6 (6:0:0): row 6, chan 0
[   40.140898] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: rank7 (7:0:0): row 7, chan 0
[   41.668192] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc(): allocating 4392 bytes for mci data (8 ranks, 8 csrows/channels)
[   41.668200] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
[   41.668203] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: rank0 (1:0:0): row 1, chan 0
[   41.668207] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: rank0 (2:0:0): row 2, chan 0
[   41.668209] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: rank0 (3:0:0): row 3, chan 0
[   41.668212] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: rank0 (4:0:0): row 4, chan 0
[   41.668215] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: rank0 (5:0:0): row 5, chan 0
[   41.668218] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: rank0 (6:0:0): row 6, chan 0
[   41.668221] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: rank0 (7:0:0): row 7, chan 0
[   42.226144] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc(): allocating 5672 bytes for mci data (8 ranks, 8 csrows/channels)
[   42.226158] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
[   42.226163] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: rank1 (1:0:0): row 1, chan 0
[   42.226166] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: rank2 (2:0:0): row 2, chan 0
[   42.226169] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: rank3 (3:0:0): row 3, chan 0
[   42.226171] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: rank4 (4:0:0): row 4, chan 0
[   42.226174] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: rank5 (5:0:0): row 5, chan 0
[   42.226177] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: rank6 (6:0:0): row 6, chan 0
[   42.226180] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: rank7 (7:0:0): row 7, chan 0
[   43.378776] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc(): allocating 4392 bytes for mci data (8 ranks, 8 csrows/channels)
[   43.379391] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
[   43.379394] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: rank0 (1:0:0): row 1, chan 0
[   43.379397] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: rank0 (2:0:0): row 2, chan 0
[   43.379400] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: rank0 (3:0:0): row 3, chan 0
[   43.379403] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: rank0 (4:0:0): row 4, chan 0
[   43.379406] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: rank0 (5:0:0): row 5, chan 0
[   43.379409] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: rank0 (6:0:0): row 6, chan 0
[   43.379412] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: rank0 (7:0:0): row 7, chan 0
[   44.179524] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc(): allocating 4392 bytes for mci data (8 ranks, 8 csrows/channels)
[   44.179534] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
[   44.179537] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: rank0 (1:0:0): row 1, chan 0
[   44.179540] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: rank0 (2:0:0): row 2, chan 0
[   44.179543] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: rank0 (3:0:0): row 3, chan 0
[   44.179546] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: rank0 (4:0:0): row 4, chan 0
[   44.179549] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: rank0 (5:0:0): row 5, chan 0
[   44.179552] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: rank0 (6:0:0): row 6, chan 0
[   44.179555] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: rank0 (7:0:0): row 7, chan 0
[   44.602994] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc(): allocating 5672 bytes for mci data (8 ranks, 8 csrows/channels)
[   44.603030] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
[   44.603041] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: rank1 (1:0:0): row 1, chan 0
[   44.603050] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: rank2 (2:0:0): row 2, chan 0
[   44.603058] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: rank3 (3:0:0): row 3, chan 0
[   44.603067] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: rank4 (4:0:0): row 4, chan 0
[   44.603075] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: rank5 (5:0:0): row 5, chan 0
[   44.603084] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: rank6 (6:0:0): row 6, chan 0
[   44.603092] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: rank7 (7:0:0): row 7, chan 0

