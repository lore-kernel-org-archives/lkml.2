Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab2BIVaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:30:16 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58884 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab2BIVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:30:14 -0500
Date: Thu, 09 Feb 2012 16:30:09 -0500 (EST)
Message-Id: <20120209.163009.1594369939327153054.davem@davemloft.net>
To: paul.gortmaker@windriver.com
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: 8250 move broke the build on sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 09 Feb 2012 13:30:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 9bef3d4197379a995fa80f81950bbbf8d32e9e8b ("serial: group all
the 8250 related code together") broke the build on sparc.

You really can't move 8250.c around without adjusting the "" includes
such as the one for "suncore.h".

Simply changing "suncore.h" to "../suncore.h" fixes things, but that's
pretty ugly if you ask me.
