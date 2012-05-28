Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2E1Snk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:43:40 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40546 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2E1Snj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:43:39 -0400
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 May 2012 14:43:39 EDT
From: Vincent Sanders <vincent.sanders@collabora.co.uk>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Add gcov support to ARM
Date: Mon, 28 May 2012 19:33:36 +0100
Message-Id: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches add the necessary support for gcov on ARM. The idea
is based on an original patch in 2010 by George G. Davis
<gdavis@mvista.com> but re-implemented against 3.4.

The approach requires the constructor symbol name be adjusted as it is
different on ARM to other platforms (I have directly tested on x86 and
arm). Currently I cannot find another platform where the symbol name
is not .ctors but it can be readily added.

Once the constructors are called correctly the actual changes to the
ARM architecture is minimal and principally involves avoiding adding
gcov compilation options to the early boot code.

