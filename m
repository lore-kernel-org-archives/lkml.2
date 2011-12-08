Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab1LHAlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:41:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:57517 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab1LHAlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:41:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="93725254"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, trenn@suse.de
Subject: Updated cpu module autoprobing patchkit
Date: Wed,  7 Dec 2011 16:41:13 -0800
Message-Id: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to popular demand a new version of the cpu module autoprobing
patchkit. This exports x86 CPUID information (features, vendors, models etc.)
in a way that udev can autoprobe modules, similar to how
USB or PCI devices are autoloaded. This allows to easily
add CPU specific modules without requiring distributions
to have special case init scripts.

The biggest difference compared to the old version is that it 
hangs off the cpuid devices now, now the cpu devices. cpu devices
were sysdevs which don't have all the infrastructure needed 
for udev. cpuid has all this so it works much better.
This requires the cpuid driver to be loaded or builtin for 
the autoprobing to work.

Any testing appreciated

-Andi

