Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0LHCUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:20:44 -0500
Received: from kroah.org ([198.145.64.141]:45837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab0LHAqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:32 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:25 2010
Message-Id: <20101208004425.004598222@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Samuel Ortiz <samuel@sortiz.org>
Subject: [006/127] irda: Fix parameter extraction stack overflow
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Samuel Ortiz <samuel@sortiz.org>

commit efc463eb508798da4243625b08c7396462cabf9f upstream.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/irda/parameters.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/irda/parameters.c
+++ b/net/irda/parameters.c
@@ -298,6 +298,8 @@ static int irda_extract_string(void *sel
 
 	p.pi = pi;     /* In case handler needs to know */
 	p.pl = buf[1]; /* Extract length of value */
+	if (p.pl > 32)
+		p.pl = 32;
 
 	IRDA_DEBUG(2, "%s(), pi=%#x, pl=%d\n", __func__,
 		   p.pi, p.pl);
@@ -318,7 +320,7 @@ static int irda_extract_string(void *sel
 		   (__u8) str[0], (__u8) str[1]);
 
 	/* Null terminate string */
-	str[p.pl+1] = '\0';
+	str[p.pl] = '\0';
 
 	p.pv.c = str; /* Handler will need to take a copy */
 


