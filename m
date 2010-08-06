Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965614Ab0HFTNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:13:47 -0400
Received: from kroah.org ([198.145.64.141]:58527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965073Ab0HFTAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:05 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:34 2010
Message-Id: <20100806185834.633490676@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [09/34] amd64_edac: Fix DCT base address selector
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit 9975a5f22a4fcc8d08035c65439900a983f891ad upstream.

The correct check is to verify whether in high range we're below 4GB
and not to extract the DctSelBaseAddr again. See "2.8.5 Routing DRAM
Requests" in the F10h BKDG.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/amd64_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1491,7 +1491,7 @@ static inline u64 f10_get_base_addr_offs
 	u64 chan_off;
 
 	if (hi_range_sel) {
-		if (!(dct_sel_base_addr & 0xFFFFF800) &&
+		if (!(dct_sel_base_addr & 0xFFFF0000) &&
 		   hole_valid && (sys_addr >= 0x100000000ULL))
 			chan_off = hole_off << 16;
 		else


