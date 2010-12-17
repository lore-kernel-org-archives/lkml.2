Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0LQCmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 21:42:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:34692 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab0LQCmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 21:42:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,358,1288594800"; 
   d="scan'208";a="688029359"
Subject: [BUG]x86: relocatable doesn't work with new binutils
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 10:42:06 +0800
Message-ID: <1292553726.2323.482.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The CONFIG_RELOCATABLE is broken with new binutils, which will make boot
panic. According to Lu Hongjiu, the affected binutils are from
2.20.51.0.12 to 2.21.51.0.3, which are release since Oct 22 this year.
At least ubuntu 10.10 is using such binutils. see:
http://sourceware.org/bugzilla/show_bug.cgi?id=12327
The reason of boot panic is we have 'jiffies = jiffies_64;' in
vmlinux.lds.S. The jiffies isn't in any section. In kernel build, there
is warning saying jiffies is an absolute address and can't be
relocatable. At runtime, jiffies will have virtual address 0.
We can easily workaround this issue by moving jiffies to a section or at
least warn people if such binutils are using. what should we do?

Thanks,
Shaohua

