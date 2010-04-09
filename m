Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab0DIKLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 06:11:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab0DIKLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 06:11:13 -0400
Date: Fri, 9 Apr 2010 06:10:54 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Octavian Purdila <opurdila@ixiacom.com>, ebiederm@xmission.com,
       Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, Amerigo Wang <amwang@redhat.com>,
       David Miller <davem@davemloft.net>
Message-Id: <20100409101442.5051.99812.sendpatchset@localhost.localdomain>
Subject: [Patch v7 0/3] net: reserve ports for applications using fixed port numbers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from the previous version:
- Update to latest Linus' tree;
- Address Eric B.'s concern, copy the whole bitmap instead of set one by one.

------------->

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


