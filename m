Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965629Ab0HFTfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:35:42 -0400
Received: from kroah.org ([198.145.64.141]:43497 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876Ab0HFT1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:27:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:15 2010
Message-Id: <20100806192115.220948566@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:19:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [09/36] amd64_edac: Correct scrub rate setting
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit bc57117856cf1e581135810b37d3b75f9d1749f5 upstream.

Exit early when setting scrub rate on unknown/unsupported families.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/amd64_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -178,7 +178,7 @@ static int amd64_set_scrub_rate(struct m
 
 	default:
 		amd64_printk(KERN_ERR, "Unsupported family!\n");
-		break;
+		return -EINVAL;
 	}
 	return amd64_search_set_scrub_rate(pvt->misc_f3_ctl, *bandwidth,
 			min_scrubrate);


