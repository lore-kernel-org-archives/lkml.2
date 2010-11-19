Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab0KSWOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:14:36 -0500
Received: from kroah.org ([198.145.64.141]:52937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758071Ab0KSWER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:17 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:24 2010
Message-Id: <20101119220124.470384648@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolas Kaiser <nikai@nikai.net>, Jens Axboe <jaxboe@fusionio.com>
Subject: [28/66] pipe: fix failure to return error code on ->confirm()
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Kaiser <nikai@nikai.net>

commit e5953cbdff26f7cbae7eff30cd9b18c4e19b7594 upstream.

The arguments were transposed, we want to assign the error code to
'ret', which is being returned.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/pipe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -382,7 +382,7 @@ pipe_read(struct kiocb *iocb, const stru
 			error = ops->confirm(pipe, buf);
 			if (error) {
 				if (!ret)
-					error = ret;
+					ret = error;
 				break;
 			}
 


