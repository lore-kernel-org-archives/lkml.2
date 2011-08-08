Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1HHAK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 20:10:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58399 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab1HHAK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:10:57 -0400
Date: Mon, 8 Aug 2011 01:10:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: agrover@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: drivers/target/target_core_transport.c breakage on i386
Message-ID: <20110808001055.GB2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit ec98f7825c6eaa4a9afb0eb518826efc8a2ed4a2
Author: Andy Grover <agrover@redhat.com>
Date:   Wed Jul 20 19:28:46 2011 +0000

    target: Eliminate usage of struct se_mem

we got
+       task_count = DIV_ROUND_UP(sectors, dev_max_sectors);
and that's sector_t/sector_t.  64bit division on i386 is no-no in
the kernel - it emits __udivdi3 call and it's not there.  Can
sectors really reach 2^32 here?

