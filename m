Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab1EUAEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:04:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674Ab1EUACx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: dpshah@google.com, namhyung@gmail.com, vgoyal@redhat.com
Subject: [PATCH 0/3] block: Per cpu merge stats and cfq fix
Date: Fri, 20 May 2011 20:02:44 -0400
Message-Id: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Here is the patch for making merge stats per cpu. While scanning the code
I also noticed that in one case I was not freeing up per cpu stats. First
patch fixes it. I also included Namhyung Kim's bio merge fix.

Thanks
Vivek

Vivek Goyal (3):
  cfq-iosched: Fix a memory leak of per cpu stats for root group
  cfq-iosched: Make IO merge related stats per cpu
  block: call elv_bio_merged() when merged

 block/blk-cgroup.c  |   22 +++++++++++++++++-----
 block/blk-cgroup.h  |    4 ++--
 block/blk-core.c    |    2 ++
 block/cfq-iosched.c |    5 +++++
 4 files changed, 26 insertions(+), 7 deletions(-)

-- 
1.7.4.4

