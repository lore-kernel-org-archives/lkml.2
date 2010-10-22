Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab0JVKrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:47:12 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57295 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab0JVKrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:47:10 -0400
Message-ID: <4CC16BBE.3080005@fusionio.com>
Date: Fri, 22 Oct 2010 12:47:26 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Single misc fix for 2.6.37-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A recently discovered problem in fs/pipe.c can cause us to
lose the error returned from buf-ops->confirm().

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.37/misc

Nicolas Kaiser (1):
      pipe: fix failure to return error code on ->confirm()

 fs/pipe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 279eef9..37eb1eb 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -382,7 +382,7 @@ pipe_read(struct kiocb *iocb, const struct iovec *_iov,
 			error = ops->confirm(pipe, buf);
 			if (error) {
 				if (!ret)
-					error = ret;
+					ret = error;
 				break;
 			}
 

-- 
Jens Axboe

