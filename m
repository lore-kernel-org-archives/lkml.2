Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0HJG5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 02:57:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56079
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473Ab0HJG50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 02:57:26 -0400
Date: Mon, 09 Aug 2010 23:57:46 -0700 (PDT)
Message-Id: <20100809.235746.115919762.davem@davemloft.net>
To: cmetcalf@tilera.com
CC: willy@linux.intel.com, linux-kernel@vger.kernel.org
Subject: perf build broke by list_head changes...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit:

commit de5d9bf6541736dc7ad264d2b5cc99bc1b2ad958
Author: Chris Metcalf <cmetcalf@tilera.com>
Date:   Fri Jul 2 13:41:14 2010 -0400

    Move list types from <linux/list.h> to <linux/types.h>.

broke the build of 'perf'.

If you move "struct list_head" into types.h, this means perf stops
building because it depends upon being able to include linux/list.h
from a userland application and at the same time be able to get the
basic data types without defining __KERNEL__ or similar.

Now that no longer occurs because the bulk of types.h is __KERNEL__
protected and thus the build breaks since "struct list_head" is
never defined.
