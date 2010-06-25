Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0FYNDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:03:17 -0400
Received: from ozlabs.org ([203.10.76.45]:38636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab0FYNDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:03:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/5] cpumask: complete CONFIG_CPUMASK_OFFSTACK
Date: Fri, 25 Jun 2010 22:33:09 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       anton@samba.org, Arnd Bergmann <arnd@arndb.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006252233.09944.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series finally gets the last remaining cpumask_t in the core
kernel, and thus allows us to make 'struct cpumask' undefined in the
CONFIG_CPUMASK_OFFSTACK case.  This gives us confidence that noone is
manipulating a cpumask except via the cpumask_ functions, so we can
finally short-allocate them (ie. nr_cpu_ids not NR_CPUS) for the
CONFIG_CPUMASK_OFFSTACK=y case.

This series has been tested on 32-bit only, so handle with care!

Cheers,
Rusty.
