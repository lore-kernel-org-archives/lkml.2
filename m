Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab0LHBQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:16:41 -0500
Received: from kroah.org ([198.145.64.141]:33692 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab0LHBDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:24 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:44 2010
Message-Id: <20101208005744.444323731@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Wang Lei <wang840925@gmail.com>,
        David Howells <dhowells@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [230/289] cifs: fix parsing of hostname in dfs referrals
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit ba03864872691c0bb580a7fb47388da337ef4aa2 upstream.

The DFS referral parsing code does a memchr() call to find the '\\'
delimiter that separates the hostname in the referral UNC from the
sharename. It then uses that value to set the length of the hostname via
pointer subtraction.  Instead of subtracting the start of the hostname
however, it subtracts the start of the UNC, which causes the code to
pass in a hostname length that is 2 bytes too long.

Regression introduced in commit 1a4240f4.

Reported-and-Tested-by: Robbert Kouprie <robbert@exx.nl>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Wang Lei <wang840925@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/dns_resolve.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -66,7 +66,7 @@ dns_resolve_server_name_to_ip(const char
 	/* Search for server name delimiter */
 	sep = memchr(hostname, '\\', len);
 	if (sep)
-		len = sep - unc;
+		len = sep - hostname;
 	else
 		cFYI(1, "%s: probably server name is whole unc: %s",
 		     __func__, unc);


