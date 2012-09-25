Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2IYIi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:38:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59093 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab2IYIix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:38:53 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 memstick: support for legacy sony memsticks
Date: Tue, 25 Sep 2012 10:38:44 +0200
Message-Id: <1348562326-10462-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I believe that I addressed most(all?) issues raised in the review, thus I
am resending the driver.


Changes from V1:

* Replaced explicit state numbers with enum items.
  I agree that code is cleaner this way.

* Swithced to using a workqueue.
  Unfortunelly, I still see that workqueue items are executed in parallel
  I suspect that this happens if one work item sleeps. In this case I
  don't want other work items to run too. I fixed this with a mutex, and anyway
  it nice to have it to guaranteee this.

* moved sg_nents into scatterlist.c/h and put that in separate patch as
  requested

* Made functions static, fixed most whitespace issues (I hope all),
  and I hope addressed all other comments by Andrew Morton.

Best regards,
	Maxim Levitsky
