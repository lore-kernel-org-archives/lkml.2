Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2HCAHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 20:07:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33314 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2HCAHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 20:07:54 -0400
Date: Thu, 2 Aug 2012 17:03:45 -0700
From: Silas Boyd-Wickizer <sbw@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/3] Use get_online_cpus to avoid races involving
 for_each_online_cpu
Message-ID: <20120803000344.GA3443@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've found 4 races involving for_each_online_cpu that could have ill
effects.  All 4 occur in code that can be compiled as modules, but
which is probably usually linked statically.  All 4 occur during
module init and/or exit.  I've written patches for 3 of the 4, and
will describe the 4th race in separate e-mail.

I've been checking the usages of for_each_online_cpu for the
possibility of races with offlining and onlining CPUs.  I used
libsparse and kernel source annotations to check that code uses
for_each_online_cpu in contexts with hotplug disabled
(e.g. get_online_cpus(), preempt_disable, ..).  I compiled with an
x86 64-bit allyesconfig and weeded out false positives (e.g. careful
use of CPU notifiers) by hand.

I've identified about 40 races, but only 4 that seem to have
unintentional and potentially harmful effects.

Here is a link to my checker code, which isn't fit for inclusion in
anything:

  http://pdos.csail.mit.edu/~sbw/online-checker/

Silas
