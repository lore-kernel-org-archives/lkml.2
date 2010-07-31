Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0GaU0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 16:26:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58187 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0GaU0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 16:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=vsP/z5lNKE/AZOuxkeMm+2U30sjXnXeYWA0qo3YLWVh9y1w7gKk6nHM8sgSP3R3WYW
         PUDGDmdBbpXiyyp18WJXkjDTYdhzegGEx1lwTPkmt6GAo6/g5EGpJvKluN0gLY49+ibj
         M9mx1ejp67vnDAMSmCK4rqUT+9zlAoEzN8jQ8=
Date: Sat, 31 Jul 2010 22:25:53 +0200
From: Dan Carpenter <error27@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] afs: destroy work queue on init failure
Message-ID: <20100731202553.GG26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can clean up the work queue on this error path.  This function is
called from afs_init().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 67cf810..654d8fd 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -100,6 +100,7 @@ int afs_open_socket(void)
 	ret = kernel_bind(socket, (struct sockaddr *) &srx, sizeof(srx));
 	if (ret < 0) {
 		sock_release(socket);
+		destroy_workqueue(afs_async_calls);
 		_leave(" = %d [bind]", ret);
 		return ret;
 	}
