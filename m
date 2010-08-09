Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab0HIX3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 19:29:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18861 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab0HIX3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 19:29:49 -0400
Date: Mon, 9 Aug 2010 16:28:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, ide <linux-ide@vger.kernel.org>
Cc: jgarzik <jgarzik@pobox.com>, torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] docbook: fix fatal error from libata
Message-Id: <20100809162830.06374768.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

'make htmldocs' has a fatal error when processing libata.xml, as seen
below.  The string "Example patterns:" (or any string with "example.*:"
in it AFAIK) causes some part of the doc generation tool chain to try to
produce an <informalexample> block without a beginning <para>, but
there is an ending </para> generated, which throws things out of kilter.

I don't even know where (what program) this is happening in.
I searched in docproc and xmlto and in some XML stylesheets without
finding anything.  If anyone can give me pointers about this, please do.
Until this is fixed, let's just spell "Example" as "Sample"
and match up the double quotation marks while there.


linux-2.6.35-git8/DOC1/Documentation/DocBook/libata.xml:6575: parser error : Opening and ending tag mismatch: programlisting line 6573 and para
   </para><para>
          ^
linux-2.6.35-git8/DOC1/Documentation/DocBook/libata.xml:6580: parser error : Opening and ending tag mismatch: para line 6575 and programlisting
</programlisting></informalexample>
                 ^
unable to parse linux-2.6.35-git8/DOC1/Documentation/DocBook/libata.xml
make[2]: *** [Documentation/DocBook/libata.html] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-git8.orig/drivers/ata/libata-core.c
+++ linux-2.6.35-git8/drivers/ata/libata-core.c
@@ -4281,7 +4281,7 @@ static const struct ata_blacklist_entry 
  *	The special characters ?, [, -, or *, can be matched using a set, eg. [*]
  *	Behaviour with malformed patterns is undefined, though generally reasonable.
  *
- *	Example patterns:  "SD1?",  "SD1[0-5]",  "*R0",  SD*1?[012]*xx"
+ *	Sample patterns:  "SD1?",  "SD1[0-5]",  "*R0",  "SD*1?[012]*xx"
  *
  *	This function uses one level of recursion per '*' in pattern.
  *	Since it calls _nothing_ else, and has _no_ explicit local variables,
