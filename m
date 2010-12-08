Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab0LHB0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:26:37 -0500
Received: from kroah.org ([198.145.64.141]:33470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470Ab0LHBC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:29 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:39 2010
Message-Id: <20101208005739.477197066@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [180/289] drm/radeon/kms: fix resume regression for some r5xx laptops
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit f24d86f1a49505cdea56728b853a5d0a3f8e3d11 upstream.

I had removed this when I switched the atom indirect io methods
to use the io bar rather than the mmio bar, but it appears it's
still needed.

Reported-by: Mark Lord <kernel@teksavvy.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atom.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -112,6 +112,7 @@ static uint32_t atom_iio_execute(struct
 			base += 3;
 			break;
 		case ATOM_IIO_WRITE:
+			(void)ctx->card->ioreg_read(ctx->card, CU16(base + 1));
 			ctx->card->ioreg_write(ctx->card, CU16(base + 1), temp);
 			base += 3;
 			break;


