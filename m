Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2CYTz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 15:55:57 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51343 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2CYTz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 15:55:56 -0400
Date: Sun, 25 Mar 2012 15:53:45 -0400 (EDT)
Message-Id: <20120325.155345.2260484991727010820.davem@davemloft.net>
To: acme@ghostprotocols.net
CC: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: perf PLT hit turns off symbol annotations
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 12:53:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PLT entries are anon memory on sparc once they are written to by the
dynamic linker.

But if we take a perf event within such a page, perf thinks it's this
JIT tmp/perf-***.map stuff.

Of course there won't be a real /tmp/perf-***.map file for this
anonymous memory, so dso__load() fails and this turns off symbol
annotation completely.

First of all, this is a very extreme way to handle being unable
to load a DSO.  We should just fail to annotate symbols in that
DSO, rather than everywhere.

Second of all, assuming code execution hits are in anonymous memory
must be JIT code is not correct either.  It can be in the PLT on
several architectures.
