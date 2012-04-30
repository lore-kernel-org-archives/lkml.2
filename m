Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2D3QTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:19:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:21868 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab2D3QTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:19:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="135223443"
Date: Mon, 30 Apr 2012 19:19:41 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: coretemp: fix oops on cpu unplug
Message-ID: <20120430161941.GA3167@otc-wbsnb-06>
References: <1335791881-1560-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1335799690.2351.100.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335799690.2351.100.camel@groeck-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 08:28:10AM -0700, Guenter Roeck wrote:
> Hi,
> 
> good catch. Couple of problems, though.
> 
> First, what number of cores are we talking about ? We should probably
> increase NUM_REAL_CORES as well. Long term, we should get rid of the
> dependency to prevent that problem from happening again, but that is a
> different issue.

It triggered by another bug. Cores on my 10-core processor have ids 0, 1,
2, 8, 9, 16, 17, 18, 24, 25. :-/
No need to change NUM_REAL_CORES at the moment.

> Second, we'll need the same code in get_core_online(). Otherwise the
> platform device can be created for the new core (if the core is
> re-enabled) but will never be deleted.

It has already handled in create_core_data().

-- 
 Kirill A. Shutemov
