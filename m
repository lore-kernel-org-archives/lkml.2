Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1GYKDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:03:04 -0400
Received: from smtp.citrix.com ([66.165.176.89]:23678 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab1GYKDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:03:01 -0400
X-IronPort-AV: E=Sophos;i="4.67,259,1309752000"; 
   d="scan'208";a="15236691"
Subject: [PATCH 0/3] minor cleanups to EFLAGS initialisation in
 ret_from_fork
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Pekka Enberg <penberg@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 25 Jul 2011 10:58:03 +0100
Message-ID: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series removes the use of a global kernel_eflags variable
from the x86_64 ret_from_fork path and (very slightly) merges the 32 and
64 bit version of that code path.

kernel_eflags could be made a __read_mostly but actually there is no
reason to prefer the value at cpu_init() time to a compile time constant
value for the initial eflags after a fork.

Ian.

