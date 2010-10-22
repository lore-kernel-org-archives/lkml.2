Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab0JVSiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:38:52 -0400
Received: from kroah.org ([198.145.64.141]:45790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0JVSiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:50 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:00 2010
Message-Id: <20101022183600.121293490@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [44/66] rose: Fix signedness issues wrt. digi count.
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 9828e6e6e3f19efcb476c567b9999891d051f52f ]

Just use explicit casts, since we really can't change the
types of structures exported to userspace which have been
around for 15 years or so.

Reported-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/rose/af_rose.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -677,7 +677,7 @@ static int rose_bind(struct socket *sock
 	if (addr_len == sizeof(struct sockaddr_rose) && addr->srose_ndigis > 1)
 		return -EINVAL;
 
-	if (addr->srose_ndigis > ROSE_MAX_DIGIS)
+	if ((unsigned int) addr->srose_ndigis > ROSE_MAX_DIGIS)
 		return -EINVAL;
 
 	if ((dev = rose_dev_get(&addr->srose_addr)) == NULL) {
@@ -737,7 +737,7 @@ static int rose_connect(struct socket *s
 	if (addr_len == sizeof(struct sockaddr_rose) && addr->srose_ndigis > 1)
 		return -EINVAL;
 
-	if (addr->srose_ndigis > ROSE_MAX_DIGIS)
+	if ((unsigned int) addr->srose_ndigis > ROSE_MAX_DIGIS)
 		return -EINVAL;
 
 	/* Source + Destination digis should not exceed ROSE_MAX_DIGIS */


