Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab2IURf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:35:27 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37030 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab2IURf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:35:26 -0400
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 18:35:25 +0100
Message-ID: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
Subject: Work queue questions
From: Dinky Verma <dverma249@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have one question regarding concurrency managed workqueue. In the
previous kernel versions, I was using
create_singlethread_workqueue("driver_wq") e.g workqueue name is
driver_wq. In my device driver with the latest kernel version, I am
doing the same to have a support in my device driver for previous
kernel versions and new kernel version, I started using
alloc_workqueue (in intention to create single threaded workqueue)
e.g.

wq = alloc_workqueue("driver_wq", WQ_UNBOUND,1);

create_singlethread_workqueue (Depricated) and alloc_workqueue creates
work queue both work on the newer kernel versions.

I have created 3 single threaded workqueues. when I do ps on linux
console, I see the workqueue thread with process id. When I am queuing
the work simultaneously on these worker threads, I found that threads
named with Kworker/X.Y will process the work from the work queue not
the one that had been created create_singlethread_workqueue.

When I schedule the three works at the same time, I saw sometimes one
Kworker/X.Y thread processes all work items.

The question is why the main worker thread that I created does not
process the work that is intended for it why instead kworker will
process it? I have queued the work using queue_work(wq,
worker_struct).

Regards,
Deepa
