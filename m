Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3ABPNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:13:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab3ABPNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:13:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/2] UAPI: Strip _UAPI prefix on header install no matter
 the whitespace
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 02 Jan 2013 15:13:02 +0000
Message-ID: <20130102151302.17074.30553.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130102151255.17074.29915.stgit@warthog.procyon.org.uk>
References: <20130102151255.17074.29915.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit:

	commit 56c176c9cac9a77249fa1736bfd792f379d61942
	Author: David Howells <dhowells@redhat.com>
	Date:   Mon Nov 26 16:29:39 2012 -0800
	Subject: UAPI: strip the _UAPI prefix from header guards during header installation

strips the _UAPI prefix from header guards, but only if there's a single space
between the cpp directive and the label.  Make it more flexible and able to
handle tabs and multiple white space characters.

Signed-off-by: David Howells <dhowell@redhat.com>
---

 scripts/headers_install.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index 6c353ae..581ca99 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -42,9 +42,9 @@ foreach my $filename (@files) {
 		$line =~ s/(^|\s)(inline)\b/$1__$2__/g;
 		$line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
 		$line =~ s/(^|\s|[(])(volatile)\b(\s|[(]|$)/$1__$2__$3/g;
-		$line =~ s/#ifndef _UAPI/#ifndef /;
-		$line =~ s/#define _UAPI/#define /;
-		$line =~ s!#endif /[*] _UAPI!#endif /* !;
+		$line =~ s/#ifndef\s+_UAPI/#ifndef /;
+		$line =~ s/#define\s+_UAPI/#define /;
+		$line =~ s!#endif\s+/[*]\s*_UAPI!#endif /* !;
 		printf {$out} "%s", $line;
 	}
 	close $out;

