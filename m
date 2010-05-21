Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198Ab0EUTp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 15:45:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31285 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449Ab0EUTpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 15:45:24 -0400
Date: Fri, 21 May 2010 12:44:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.freedesktop.org
Subject: Re: [git pull] drm for 2.6.35-rc1 (revised)
Message-Id: <20100521124447.67e92a7f.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.2.00.1005211154120.3689@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1005190310010.1205@skynet.skynet.ie>
	<alpine.DEB.2.00.1005210718460.16929@skynet.skynet.ie>
	<alpine.LFD.2.00.1005211154120.3689@i5.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4BF6E2BB.007E:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 11:56:39 -0700 (PDT) Linus Torvalds wrote:

> 
> 
> Grrr. Not well tested. On x86, I get several warnings like this:
> 
> 	drivers/video/fbmem.c: In function ‘fb_do_apertures_overlap’:
> 	drivers/video/fbmem.c:1494: warning: format ‘%llx’ expects type ‘long long unsigned int’, but argument 2 has type ‘resource_size_t’
> 
> Please fix. And please test the thing. 

I sent a patch for this a few days ago.  Below.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk formats:

drivers/video/fbmem.c: In function 'fb_do_apertures_overlap':
drivers/video/fbmem.c:1494: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
drivers/video/fbmem.c:1494: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
drivers/video/fbmem.c:1494: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/video/fbmem.c:1494: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/video/fbmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-next-20100519.orig/drivers/video/fbmem.c
+++ linux-next-20100519/drivers/video/fbmem.c
@@ -1491,7 +1491,10 @@ static bool fb_do_apertures_overlap(stru
 		for (j = 0; j < gena->count; ++j) {
 			struct aperture *g = &gena->ranges[j];
 			printk(KERN_DEBUG "checking generic (%llx %llx) vs hw (%llx %llx)\n",
-				g->base, g->size, h->base, h->size);
+				(unsigned long long)g->base,
+				(unsigned long long)g->size,
+				(unsigned long long)h->base,
+				(unsigned long long)h->size);
 			if (apertures_overlap(g, h))
 				return true;
 		}
