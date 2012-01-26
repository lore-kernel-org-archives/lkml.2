Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab2AZWcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:32:07 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35381 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2AZWcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:32:04 -0500
Date: Thu, 26 Jan 2012 17:32:02 -0500 (EST)
Message-Id: <20120126.173202.2207050843577467461.davem@davemloft.net>
To: sparclinux@vger.kernel.org
CC: viro@ZenIV.linux.org.uk, dmitry.kasatkin@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Fix the sparc32 mpilib build mess.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 14:32:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The long and short of it is that the longlong.h header added by
the mpilib code is quite old and out of date.

Here I've solved the clz_tab[] multiple definition problem as
well as the outdated udiv_qrnnd() definition, but long term
we should probably have a more uptodate longlong.h header
provides at include/linux/longlong.h to avoid this kind of
stuff in the future.

It's a part of the libgcc interface and therefore has no
business being tucked down deep under lib/foo/ somewhere.
