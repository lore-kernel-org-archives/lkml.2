Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0GWFyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:54:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40683 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0GWFyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QAZqhDBlfbNlbdDcKKPFdYzDiweAz7LZ1ygzNcmpODSR85Xa/0v3NEMV+qzluLZp47
         CnPRYuH9fcYkKyjZFowi9lf42mb4W6jTcFQi/EKqfT3jXtUekFsdt3u5sfm/BX08uM98
         EaQIAOzfpP/SqC5+nNikfhsY9s1xqtflG3jis=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 00/12] sound/alsa/soc/codec: fix memory leak and resource relaim in error path
Date: Fri, 23 Jul 2010 05:53:42 +0000
Message-Id: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serial of patches fixes memory leak and resource relaim in error path

I made a mistake that changed the subject line for some of the update patches.
So. here is a re-send and all patches are marked as v2.

Regards,
Axel

changes for v2:
  wm8940: follow Guennadi's comment to move the buffer allocate and release
          at the same level to prevent the memory leak.
  wm9081: follow Guennadi's comment to move the buffer allocate and release
          at the same level to prevent the memory leak.

Axel Lin (12):
  ad1836: fix a memory leak if another ad1836 is registered
  ak4642: fix a memory leak if failed to initialise AK4642
  da7210: fix a memory leak if failed to initialise da7210 audio codec
  wm8523: fix resource reclaim in wm8523_register error path
  wm8711: fix a memory leak if another WM8711 is registered
  wm8904: fix resource reclaim in wm8904_register error path
  wm8940: fix a memory leak if wm8940_register return error
  wm8955: fix resource reclaim in wm8955_register error path
  wm8961: fix resource reclaim in wm8961_register error path
  wm8974: fix a memory leak if another WM8974 is registered
  wm8978: fix a memory leak if a wm8978_register fail
  wm9081: fix resource reclaim in wm9081_register error path

 sound/soc/codecs/ad1836.c |    1 +
 sound/soc/codecs/ak4642.c |    4 +++-
 sound/soc/codecs/da7210.c |    8 ++++++--
 sound/soc/codecs/wm8523.c |   10 ++++++----
 sound/soc/codecs/wm8711.c |    3 ++-
 sound/soc/codecs/wm8904.c |   13 ++++++++-----
 sound/soc/codecs/wm8940.c |    7 ++++++-
 sound/soc/codecs/wm8955.c |   10 ++++++----
 sound/soc/codecs/wm8961.c |    9 +++++----
 sound/soc/codecs/wm8974.c |    3 ++-
 sound/soc/codecs/wm8978.c |   10 +++++++---
 sound/soc/codecs/wm9081.c |   11 ++++++-----
 12 files changed, 58 insertions(+), 31 deletions(-)

