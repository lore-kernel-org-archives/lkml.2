Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0ECFcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 01:32:08 -0400
Received: from smtp.nokia.com ([192.100.122.233]:27473 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0ECFb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 01:31:59 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 0/1] drivers: misc: pass pointer to misc device itself
Date: Mon,  3 May 2010 08:31:32 +0300
Message-Id: <1272864693-27343-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 03 May 2010 05:31:37.0690 (UTC) FILETIME=[E6C60BA0:01CAEA81]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have not found a reasonable way to find an address of the
misc-device structure in the driver file operations.
inode->i_cdev is not pointing to the correct place due to way how
misc driver class is implemented - or I have totally missed something.
In misc open, information is available but it is not passed to the
driver itself. Privatedata field of the file struct passes now
pointer to the driver open function. Driver can do what ever needed
with that information.

Samu Onkalo (1):
  drivers: misc: pass miscdevice pointer via file private data

 drivers/char/misc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

