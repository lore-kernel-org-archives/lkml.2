Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab0JVHas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:30:48 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:49437 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0JVHas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:30:48 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [-next] staging/vme: various fixes + new driver model for VME
Date: Fri, 22 Oct 2010 02:36:22 -0400
Message-Id: <1287729412-24356-1-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This contains first a whole bunch of fixes to the existing vme
code in staging, to then introduce a new driver model for VME
in patch 27.

I have a short list of things to do after this patchset gets
reviewed:

- provide a saner API for VME drivers that just want to
  map/unmap chunks of memory (knowing nothing about underlying
  hardware features, such as windows). This is already
  implemented in the out-of-tree driver in [1].

- Make DMA work on the tsi148 (it's the only bridge I've got).
  This will probably involve changing or extending the
  current API.

- Test the whole thing with real hardware and a real VME driver
  (currently out of tree as well, see [2]), which I'll try
  to get merged, too--currently we just have vme_user.c which
  really isn't a kosher driver.



Note that the appended applies on top of linux-next.

The patchset can be pulled from:
git://github.com/cota/linux-2.6.git vme-next

Thanks,

                Emilio


[1] http://repo.or.cz/w/ht-drivers.git/tree/HEAD:/vmebridge/driver
[2] http://repo.or.cz/w/ht-drivers.git/tree/HEAD:/sis33/drivers

diffstat:

 drivers/staging/vme/bridges/vme_ca91cx42.c |  222 ++++++------
 drivers/staging/vme/bridges/vme_ca91cx42.h |    2 +-
 drivers/staging/vme/bridges/vme_tsi148.c   |  259 +++++++-------
 drivers/staging/vme/bridges/vme_tsi148.h   |    2 +-
 drivers/staging/vme/devices/vme_user.c     |  159 ++++-----
 drivers/staging/vme/vme.c                  |  569 +++++++++++++++-------------
 drivers/staging/vme/vme.h                  |  229 ++++++++++-
 drivers/staging/vme/vme_bridge.h           |  175 ---------
 8 files changed, 831 insertions(+), 786 deletions(-)


