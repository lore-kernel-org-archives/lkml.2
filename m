Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab2EWKku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:40:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37773 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab2EWKkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:40:35 -0400
Message-Id: <20120523102541.382837149@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 23 May 2012 14:25:41 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, ebiederm@xmission.com,
        tj@kernel.org, skinsbursky@openvz.org
Subject: [rfc v2 0/7] procfs fdinfo extension v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here is an updated version of "get more detailed fdinfo" on
eventfd/epoll/fsnotify files. The main change from previous
version is that now almost everything is under CONFIG_CHECKPOINT_RESTORE
config symbol (except of conversion of fdinfo proc handling routines
to seq files which I think increase readability for mainline as well).
I've tried hard to minimaze impact on source code.

The comments and espec. complains are highly appreciated (even proposal
of some different design is welcome).

Andrew, as to questions what else needed for c/r in mainline -- that's
what I counted (at least at moment)

 - fdinfo to restore eventfd/epoll/fsnotify (this series)

 - restore of file-owner UIDs (there were a series from
   Eric for mapping kernel-uids to user-uids, so I'm waiting
   for their final merge before I adopt my patch and send it out
   (maybe I've missed something and the whole Eric's series already
   in linux-next, need to check)

 - IPC c/r (there were a series from Stas not sure what status
   of them at moment, as far as I remember they should be rewored)

 - finally it would be great to have ability to attach tasks to
   frozen tasks cgroup to thaw them at one moment (the preliminary
   patch I've proposed pretty long ago, but Tejun was modifying cgroups
   code and asked to wait until 3.4 is release, so I didn't check
   the current status of task cgroups at moment, I've it in my todo list)

that's all I know.

	Cyrill
