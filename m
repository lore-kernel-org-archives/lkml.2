Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab2BYDP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 22:15:26 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41711 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2BYDPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 22:15:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of andrey.warkentin@gmail.com designates 10.229.136.77 as permitted sender) smtp.mail=andrey.warkentin@gmail.com; dkim=pass header.i=andrey.warkentin@gmail.com
From: Andrei Warkentin <andrey.warkentin@gmail.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        andreiw@vmware.com
Subject: NetKGDB support.
Date: Fri, 24 Feb 2012 21:15:07 -0500
Message-Id: <1330136109-2518-1-git-send-email-andrey.warkentin@gmail.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is tentative patch set I am sending for feedback. It
implements a network I/O backend for KDB/KGDB, the kernel
debugger.

Very similar to netconsole, on which it is based, but with
a crucial difference - netkgdb is designed to accept connections
from any hosts, i.e. it is not necessary to specify these ahead
of time. This makes it that much more useful in a "this host crashed
and a I want a developer to take a look at it" scenario, common to
large scale test/QA farms and automated testing harnesses. This
involves a minor change to the netpoll rx_hook, namely, to provide
source connection information.

[PATCH 1/2] NETPOLL: Extend rx_hook support.
[PATCH 2/2] NETKGDB: Ethernet/UDP/IP KDB transport.

Thanks,
A
