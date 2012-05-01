Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2EAU7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:59:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:17742 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab2EAU7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:59:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148199595"
Date: Wed, 2 May 2012 00:00:41 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: coretemp: fix oops on cpu unplug
Message-ID: <20120501210041.GA10629@otc-wbsnb-06>
References: <1335791881-1560-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120501152014.GA2629@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501152014.GA2629@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 08:20:14AM -0700, Guenter Roeck wrote:
> On Mon, Apr 30, 2012 at 09:18:01AM -0400, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > coretemp tries to access core_data array beyond bounds on cpu unplug if
> > core id of the cpu if more than NUM_REAL_CORES-1.
> > 
> [ ... ]
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> 
> Looking at it again, you were right. Adding the check to get_core_online()
> doesn't really help as the platform device is per CPU, not per core.
> 
> Applied. I'll submit a separate patch to increase NUM_REAL_CORES.

Actually, the problem is bigger.

Documentation/cputopology.txt:
====
2) /sys/devices/system/cpu/cpuX/topology/core_id:

        the CPU core ID of cpuX. Typically it is the hardware platform's
        identifier (rather than the kernel's).  The actual value is
        architecture and platform dependent.
====

We should not use core id as an index in an array since it's an arbitrary
number (from kernel POV).

-- 
 Kirill A. Shutemov
