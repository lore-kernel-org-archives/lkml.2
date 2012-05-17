Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967764Ab2EQWOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:14:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:65435 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966116Ab2EQWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:13:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145320358"
From: "H.J. Lu" <hjl.tools@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, "H.J. Lu" <hjl.tools@gmail.com>
Subject: [RFC PATCH 00/10] Use __kernel_[u]long_t for x32 user space compatibility
Date: Thu, 17 May 2012 15:13:26 -0700
Message-Id: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H.J. Lu <hjl.tools@gmail.com>

This patch set changes a number of places where the kernel headers are
exported to user space and currently use explicit "long" or "unsigned
long" to use __kernel_[u]long_t in order to be compatible with the x32
user space ABI.  These location are places where x32 uses the x86-64
ABI.

It is quite possible that some, or even all, of these locations should
really use dedicated types, but in the meantime this gives the correct
results which the current headers do not.

