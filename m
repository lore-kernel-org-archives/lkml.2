Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab1LGQQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:16:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab1LGQQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:16:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:23 2011
Message-Id: <20111207160823.448487260@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:30 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [10/80] drm/ttm: request zeroed system memory pages for new TT buffer objects
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit ff02b13f6867af72682d7a9bb9bd705f9af2bab0 upstream.

Fixes an information leak to userspace, we were handing out un-zeroed pages
for any newly created TTM_PL_TT buffer.

Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/ttm/ttm_bo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -394,7 +394,8 @@ static int ttm_bo_handle_move_mem(struct
 
 	if (!(new_man->flags & TTM_MEMTYPE_FLAG_FIXED)) {
 		if (bo->ttm == NULL) {
-			ret = ttm_bo_add_ttm(bo, false);
+			bool zero = !(old_man->flags & TTM_MEMTYPE_FLAG_FIXED);
+			ret = ttm_bo_add_ttm(bo, zero);
 			if (ret)
 				goto out_err;
 		}


