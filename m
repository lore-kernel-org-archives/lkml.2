Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0KVIhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:37:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33207 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0KVIho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:37:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gDzes6UkK3jEj5MM6vb5769HAQ5mBBqOZFLtgP6hocjOEg7uws9RnvVWC5/wnVRnPI
         DxmuRRv8HBDxN+to46hJTOXhUh52rB4sDAOdFZ3MJvOw5Nh5jjfMl4OhnwJXpeutkhy6
         BI6hiDYV2cZBRnRKrB5/mnGCZCiIn2+YeVTqc=
Subject: [PATCH 0/4] fix a memory leak related to
	request_mem_region/release_mem_region usage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mmc@vger.kernel.org, Vipin Bhandari <vipin.bhandari@ti.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Nicolas Pitre <nico@fluxnic.net>, Eric Miao <eric.y.miao@gmail.com>
Content-Type: text/plain
Date: Mon, 22 Nov 2010 16:42:39 +0800
Message-Id: <1290415359.5471.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serial of patches fixes a memory leak related to request_mem_region
and release_mem_region usage.

request_mem_region() will call kzalloc to allocate memory for struct resource.
release_resource() unregisters the resource but does not free the allocated
memory, thus use release_mem_region() instead to fix the memory leak.


Axel Lin (4):
  [ARM] davinci_mmc: fix a memory leak
  [ARM] mvsdio: fix a memory leak
  [ARM] pxamci: fix a memory leak
  [ARM] mxcmmc: remove a unnecessary release_resource() call

 drivers/mmc/host/davinci_mmc.c |    5 +++--
 drivers/mmc/host/mvsdio.c      |    4 ++--
 drivers/mmc/host/mxcmmc.c      |    1 -
 drivers/mmc/host/pxamci.c      |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
1.7.2



