Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab2B0Ea2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:30:28 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:42463 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2B0Ea1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:30:27 -0500
From: Andrei Warkentin <andrey.warkentin@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: NetKGDB v3
Date: Sun, 26 Feb 2012 22:30:08 -0500
Message-Id: <1330313411-845-1-git-send-email-andrey.warkentin@gmail.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330137851-4716-1-git-send-email-andrey.warkentin@gmail.com>
References: <1330137851-4716-1-git-send-email-andrey.warkentin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v3 of the tentative patch set I am sending for feedback.
It implements a network I/O backend for KDB/KGDB, the kernel
debugger.

NetKGDB is very similar to netconsole, on which it is based, but with
a crucial difference - netkgdb is designed to accept connections
from any hosts, i.e. it is not necessary to specify these ahead
of time. This makes it that much more useful in a "this host crashed
and a I want a developer to take a look at it" scenario, common to
large scale test/QA farms and automated testing harnesses. This
involves a minor change to the netpoll rx_hook, namely, to provide
source connection information.

This differs from v2 in adding the flush() callback in kgdb_io,
which would be necessary for correct behavior in gdbstub mode,
and enhances the debug core to support registering multiple
I/O ops. The later allows both kgdboc, netkgdb and any other
providers to coexist peacefully, and allow debugging both
interactively and via the network.

V2 cleaned up a lot of the strange cruft in v1 surrounding
dealing with netdev notifiers.

[PATCHv3 1/3] NETPOLL: Extend rx_hook support.
[PATCHv3 2/3] NETKGDB: Ethernet/UDP/IP KDB transport.
[PATCHv3 3/3] KGDB: Allow registering multiple I/O ops.

Thanks,
A
