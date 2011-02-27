Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab1B0Jbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 04:31:53 -0500
Received: from adsl-99-49-45-148.dsl.austtx.sbcglobal.net ([99.49.45.148]:45591
	"EHLO 99.49.47.21" rhost-flags-OK-OK-FAIL-FAIL) by vger.kernel.org
	with ESMTP id S1751518Ab1B0Jbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 04:31:51 -0500
X-Greylist: delayed 3581 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Feb 2011 04:31:51 EST
Subject: Re: [PATCH v2 1/2] USB: ffs-test: fix header path
From: Davidlohr Bueso <dave@gnu.org>
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, Michal Nazarewicz <m.nazarewicz@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
In-Reply-To: <20110217190554.GA25833@suse.de>
References: <1297012413.2039.8.camel@offworld>
	 <20110217184257.GA13545@kroah.com> <1297969052.21769.0.camel@offworld>
	 <20110217190554.GA25833@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 04:58:48 -0300
Message-ID: <1298793528.2284.2.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 11:05 -0800, Greg KH wrote:
> On Thu, Feb 17, 2011 at 03:57:32PM -0300, Davidlohr Bueso wrote:
> > On Thu, 2011-02-17 at 10:42 -0800, Greg KH wrote:
> > > On Sun, Feb 06, 2011 at 02:13:33PM -0300, Davidlohr Bueso wrote:
> > > > From: Davidlohr Bueso <dave@gnu.org>
> > > > 
> > > > When compiling this program the functionfs.h header cannot be found, producing:
> > > > ffs-test.c:40: fatal error: linux/usb/functionfs.h: No such file or directory
> > > > 
> > > > This patch also fixes the following warning:
> > > > ffs-test.c:453: warning: format ‘%4d’ expects type ‘int’, but argument 3 has type ‘size_t’
> > > > 
> > > > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > > > ---
> > > >  tools/usb/ffs-test.c |    4 ++--
> > > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > This patch doesn't apply properly to the linux-next branch, what did you
> > > make it against?
> > > 
> > 
> > It was against Linus' tree (did a pull right before submitting the
> > patch).
> 
> Ah, so you think this is needed for Linus's tree now?  Care to resend it
> and I'll queue it up to the proper tree, sorry, I missed that.
> 
Sorry about the delay, you wouldn't believe the problems I have with a
slow ('90s) internet connection when trying to clone a tree. Here is a
version against the latest linux-next. Thanks.

From: Davidlohr Bueso <dave@gnu.org>
Date: Sun, 27 Feb 2011 04:55:59 -0300
Subject: [PATCH] USB: ffs-test: fix header path

When compiling this program the functionfs.h header cannot be found, producing:
ffs-test.c:40: fatal error: linux/usb/functionfs.h: No such file or directory

This patch also fixes the following warning:
ffs-test.c:453: warning: format ‘%4d’ expects type ‘int’, but argument 3 has type ‘size_t’

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 tools/usb/ffs-test.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index bbe2e3a..b9c7986 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -37,7 +37,7 @@
 #include <sys/types.h>
 #include <unistd.h>
 
-#include <linux/usb/functionfs.h>
+#include "../../include/linux/usb/functionfs.h"
 
 
 /******************** Little Endian Handling ********************************/
@@ -450,7 +450,7 @@ invalid:
 		    len, expected, *p);
 		for (p = buf, len = 0; len < nbytes; ++p, ++len) {
 			if (0 == (len % 32))
-				fprintf(stderr, "%4d:", len);
+				fprintf(stderr, "%4zd:", len);
 			fprintf(stderr, " %02x", *p);
 			if (31 == (len % 32))
 				fprintf(stderr, "\n");
-- 
1.7.1



