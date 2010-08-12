Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782Ab0HLKm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 06:42:28 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:49023 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365Ab0HLKmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 06:42:25 -0400
Date: Thu, 12 Aug 2010 12:44:13 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andreas Schwab <schwab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] partitions: fix build error in ibm partition detection
 code
Message-ID: <20100812104413.GD7814@osiris.boeblingen.de.ibm.com>
References: <20100812083104.GC7814@osiris.boeblingen.de.ibm.com>
 <m31va4nre5.fsf@hase.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m31va4nre5.fsf@hase.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 10:53:38AM +0200, Andreas Schwab wrote:
> Heiko Carstens <heiko.carstens@de.ibm.com> writes:
> 
> > -				strlcat(tmp, sizeof(tmp), "(nonl)", PAGE_SIZE);
> > +				snprintf(tmp, sizeof(tmp), "(nonl)");
> > +				strlcat(state->pp_buf, tmp, PAGE_SIZE);
> 
> What's the point of tmp and snprintf if it just creates a copy of a
> constant string?
> 
> 				strlcat(state->pp_buf, "(nonl)", PAGE_SIZE);

There's no point, just followed the pattern in the original patch without
thinking. Thanks! Updated patch:

Subject: [PATCH] partitions: fix build error in ibm partition detection code

From: Heiko Carstens <heiko.carstens@de.ibm.com>

9c867fbe "partitions: fix sometimes unreadable partition strings" coverted
one line within the ibm partition code incorrectly. Fix this to get rid of
a build error.

fs/partitions/ibm.c: In function 'ibm_partition':
[...]
fs/partitions/ibm.c:185: error: too many arguments to function 'strlcat'

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/partitions/ibm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -182,7 +182,7 @@ int ibm_partition(struct parsed_partitio
 				offset = (info->label_block + 1);
 			} else {
 				/* unlabeled disk */
-				strlcat(tmp, sizeof(tmp), "(nonl)", PAGE_SIZE);
+				strlcat(state->pp_buf, "(nonl)", PAGE_SIZE);
 				size = i_size >> 9;
 				offset = (info->label_block + 1);
 			}
