Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab0JVS4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:14 -0400
Received: from kroah.org ([198.145.64.141]:34009 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260Ab0JVS4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:29 2010
Message-Id: <20101022185229.483168553@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [024/103] V4L/DVB: gspca - sn9c20x: Bad transfer size of Bayer images
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean-François Moine <moinejf@free.fr>

commit 04d174e99a6eca2f62b56c10ae1d7d0499d83e9d upstream.

As the end of frame marker does not contain any pixel, it must not be
transferred.

Reported-by: Ivo Jager <ivo.jager@siliconfields.net>
Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/sn9c20x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -2368,8 +2368,7 @@ static void sd_pkt_scan(struct gspca_dev
 			    (data[33] << 10);
 		avg_lum >>= 9;
 		atomic_set(&sd->avg_lum, avg_lum);
-		gspca_frame_add(gspca_dev, LAST_PACKET,
-				data, len);
+		gspca_frame_add(gspca_dev, LAST_PACKET, NULL, 0);
 		return;
 	}
 	if (gspca_dev->last_packet_type == LAST_PACKET) {


