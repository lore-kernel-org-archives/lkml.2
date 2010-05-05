Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442Ab0EEK1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:27:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759221Ab0EEK1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:27:00 -0400
Date: Wed, 5 May 2010 06:26:34 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Octavian Purdila <opurdila@ixiacom.com>, ebiederm@xmission.com,
       Eric Dumazet <eric.dumazet@gmail.com>,
       penguin-kernel@I-love.SAKURA.ne.jp, netdev@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, Amerigo Wang <amwang@redhat.com>,
       xiaosuo@gmail.com, adobriyan@gmail.com,
       David Miller <davem@davemloft.net>
Message-Id: <20100505103033.5600.77502.sendpatchset@localhost.localdomain>
Subject: [Patch v10 0/3] net: reserve ports for applications using fixed port numbers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes from the previous version:
- Use 'true' and 'false' for bool's;
- Fix some coding style problems;
- Allow appending lines to bitmap proc file so that it will be
  easier to add new bits.

------------------>

This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports which
allows users to reserve ports for third-party applications.

The reserved ports will not be used by automatic port assignments
(e.g. when calling connect() or bind() with port number 0). Explicit
port allocation behavior is unchanged.

There are still some miss behaviors with regard to proc parsing in odd
invalid cases (for "40000\0-40001" all is acknowledged but only 40000
is accepted) but they are not easy to fix without changing the current
"acknowledge how much we accepted" behavior.

Because of that and because the same issues are present in the
existing proc_dointvec code as well I don't think its worth holding
the actual feature (port reservation) after such petty error recovery
issues.


