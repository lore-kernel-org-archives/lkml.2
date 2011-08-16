Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1HPCqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:46:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:31698 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab1HPCqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:46:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,378,1309762800"; 
   d="scan'208";a="41784498"
Subject: cfq-iosched: a regression
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: teravest@google.com, lkml <linux-kernel@vger.kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 10:47:06 +0800
Message-ID: <1313462826.27321.22.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a kernel build regression since 3.1-rc1, which is about 10%
regression. The kernel source is in an ext3 filesystem.
Alex Shi bisect it to commit:
commit a07405b7802691d29ab3b23bdc76ee6d006aad0b
Author: Justin TerAvest <teravest@google.com>
Date:   Sun Jul 10 22:09:19 2011 +0200

    cfq: Remove special treatment for metadata rqs.

Apparently this is caused by lack metadata preemption, where ext3/ext4
do use READ_META. I didn't see a way to fix the issue, so suggest
reverting the patch.

Reported-by: Alex Shi<alex.shi@intel.com>
Reported-by: Shaohua Li<shaohua.li@intel.com>

