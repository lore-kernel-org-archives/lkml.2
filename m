Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2EFLM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 07:12:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:58300 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab2EFLM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 07:12:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="137513467"
Date: Sun, 6 May 2012 14:14:12 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] smb347_charger: cleaned battery power supply attributes
Message-ID: <20120506111412.GG31494@intel.com>
References: <1336233834-21550-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336233834-21550-1-git-send-email-ramakrishna.pallala@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 09:33:54PM +0530, Ramakrishna Pallala wrote:
> CURRENT_NOW and VOLTAGE_NOW should be instantaneous readings
> from power supply(ex: battery).
> 
> smb347 charger driver reports charge voltage for VOLTAGE_NOW
> and charge current for CURRENT_NOW attributes which are not
> instantaneous readings.
> 
> This patch removes the battery VOLTAGE_NOW and CURRENT_NOW
> properties from the driver and also removes hw_to_current()
> which is not required anymore.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>

I agree. As the chip only reports voltage and current what is configured
(and not the actual values) these attributes are pretty much useless and I
should've never introduced them in the first place. A separate Fuel Gauge
or similar is right place to get the actual values.

As long as Anton is ok with this, you can add my

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
