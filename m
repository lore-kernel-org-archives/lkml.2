Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934727Ab1IOUKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:10:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:9031 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934488Ab1IOUKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="51959229"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: Tree sweep to fix up initconst
Date: Thu, 15 Sep 2011 13:09:27 -0700
Message-Id: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a global tree sweep to fix up initconst section problems.

Any variable const in initdata must be marked __initconst, not initdata.
const __read_mostly is not allowed.

Otherwise the global sections can get a read only marking and in some
circumstances the compiler/and or the linker will detect conflicts.

This patchkit aims to fix it up everywhere.

Also available in git://github.com/andikleen/linux-misc.git const-sections

Note I plan to ask Linus to pull this directly.

-Andi
