Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1EFAvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:51:38 -0400
Received: from kroah.org ([198.145.64.141]:36913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab1EFAZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:12 2011
Message-Id: <20110506002212.101731211@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jovi Zhang <bookjovi@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [070/143] nfs: fix compilation warning
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jovi Zhang <bookjovi@gmail.com>

commit 43b7c3f051dea504afccc39bcb56d8e26c2e0b77 upstream.

this commit fix compilation warning as following:
linux-2.6/fs/nfs/nfs4proc.c:3265: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3142,7 +3142,7 @@ static int buf_to_pages_noslab(const voi
 	spages = pages;
 
 	do {
-		len = min(PAGE_CACHE_SIZE, buflen);
+		len = min_t(size_t, PAGE_CACHE_SIZE, buflen);
 		newpage = alloc_page(GFP_KERNEL);
 
 		if (newpage == NULL)


