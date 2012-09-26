Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2IZJtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:49:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45896 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2IZJtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:49:09 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH v3 memstick: support for legacy sony memsticks
Date: Wed, 26 Sep 2012 11:48:59 +0200
Message-Id: <1348652941-31899-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am sending an updated version of the driver, this time
addressing comments by Tejun Heo


Changes since V2:

* Removed the mutex kludge - ordered worqueue indeed works well
* Removed manul major/minor handling
* Gave more specific names to two sg helpers.

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


