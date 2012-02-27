Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2B0DFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 22:05:53 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63561 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2B0DFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 22:05:52 -0500
From: Andrei Warkentin <andrey.warkentin@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: NetKGDB support v2
Date: Sun, 26 Feb 2012 21:05:35 -0500
Message-Id: <1330308337-21365-1-git-send-email-andrey.warkentin@gmail.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330137851-4716-1-git-send-email-andrey.warkentin@gmail.com>
References: <1330137851-4716-1-git-send-email-andrey.warkentin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This is v2 of the tentative patch set I am sending for feedback.
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

This differs from v1 in cleaning up the netdev notifier code, which
was needlessly byzantine and had potential races, and in some docu-
mentation changes.

I've also Cc'd Matt Mackall, who wrote the current netconsole code.

[PATCHv2 1/2] NETPOLL: Extend rx_hook support.
[PATCHv2 2/2] NETKGDB: Ethernet/UDP/IP KDB transport.
