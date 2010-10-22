Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866Ab0JVTRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:17:23 -0400
Received: from kroah.org ([198.145.64.141]:34088 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759316Ab0JVS4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:20 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:30 2010
Message-Id: <20101022185230.756319069@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Aristeu Rozanski <aris@redhat.com>, Ping Cheng <pingc@wacom.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [038/103] Input: wacom - fix pressure in Cintiq 21UX2
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aristeu Rozanski <aris@redhat.com>

commit ca047fedd89bbb4b79b61e0656a7b799e4e45e6d upstream.

Currently the pressure range in Cintiq 21UX2 is limited to half of the
supported. This patch fixes the problem.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Acked-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/tablet/wacom_wac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -409,8 +409,10 @@ static void wacom_intuos_general(struct
 	/* general pen packet */
 	if ((data[1] & 0xb8) == 0xa0) {
 		t = (data[6] << 2) | ((data[7] >> 6) & 3);
-		if (features->type >= INTUOS4S && features->type <= INTUOS4L)
+		if ((features->type >= INTUOS4S && features->type <= INTUOS4L) ||
+		    features->type == WACOM_21UX2) {
 			t = (t << 1) | (data[1] & 1);
+		}
 		input_report_abs(input, ABS_PRESSURE, t);
 		input_report_abs(input, ABS_TILT_X,
 				((data[7] << 1) & 0x7e) | (data[8] >> 7));


