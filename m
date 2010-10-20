Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0JTOzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:55:21 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:34669 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725Ab0JTOzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:55:19 -0400
Date: Wed, 20 Oct 2010 16:50:47 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: return error on error condition
Message-ID: <20101020165047.09150171@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's intended to return an error, right?

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
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
1.7.2.2
