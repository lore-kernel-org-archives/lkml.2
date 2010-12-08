Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab0LHBdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:33:36 -0500
Received: from kroah.org ([198.145.64.141]:49049 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab0LHBBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:39 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:35 2010
Message-Id: <20101208005735.800110695@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [144/289] [media] gspca - sonixj: Fix a regression of sensors hv7131r and mi0360
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>

commit 0303a90a744662e934877a5d637a43197229274b upstream.

The bug was introduced by commit 23a98274cc348880ecb6803307c254448084953a
applying values of sensor sp80708 to sensors hv7131r and mi0360.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/sonixj.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -2474,8 +2474,7 @@ static int sd_start(struct gspca_dev *gs
 		reg1 = 0x44;
 		reg17 = 0xa2;
 		break;
-	default:
-/*	case SENSOR_SP80708: */
+	case SENSOR_SP80708:
 		init = sp80708_sensor_param1;
 		if (mode) {
 /*??			reg1 = 0x04;	 * 320 clk 48Mhz */


