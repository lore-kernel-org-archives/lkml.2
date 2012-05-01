Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab2EAPWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:22:44 -0400
Received: from imr3.ericy.com ([198.24.6.13]:33011 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab2EAPWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:22:42 -0400
Date: Tue, 1 May 2012 08:20:14 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: coretemp: fix oops on cpu unplug
Message-ID: <20120501152014.GA2629@ericsson.com>
References: <1335791881-1560-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1335791881-1560-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 09:18:01AM -0400, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> coretemp tries to access core_data array beyond bounds on cpu unplug if
> core id of the cpu if more than NUM_REAL_CORES-1.
> 
[ ... ]
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Looking at it again, you were right. Adding the check to get_core_online()
doesn't really help as the platform device is per CPU, not per core.

Applied. I'll submit a separate patch to increase NUM_REAL_CORES.

Guenter
