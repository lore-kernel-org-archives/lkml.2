Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0H3T27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:28:59 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:34712 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab0H3T26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:28:58 -0400
Subject: [PATCH] HID: roccat: Normalized reported profile number for pyra
 button events.
From: Stefan Achatz <stefan_achatz@web.de>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, Kees Bakker <kees.bakker@xs4all.nl>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 21:28:56 +0200
Message-ID: <1283196536.2059.0.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX198wRZ6rKN02PL3b+TAoxUE3JlwXJmQg2gbHQbM
	xpDtn6+TFvS0b63PdE9CNWQYhoSS3J8khHfOppySFIxLmUGbjM
	v6wGAgVAaUjzaCNoPTHQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pyra uses profile numbers in range 0-4 for everything except button
events. Using range 1-5 consistent now.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-pyra.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-roccat-pyra.c
b/drivers/hid/hid-roccat-pyra.c
index 6c09c15..9bf2304 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -902,7 +902,11 @@ static void pyra_report_to_chrdev(struct
pyra_device const *pyra,
 		if (button_event->data2 == PYRA_MOUSE_EVENT_BUTTON_PRESS) {
 			roccat_report.type = button_event->type;
 			roccat_report.key = button_event->data1;
-			roccat_report.value = pyra->actual_profile;
+			/*
+			 * pyra reports profile numbers with range 1-5.
+			 * Keeping this behaviour.
+			 */
+			roccat_report.value = pyra->actual_profile + 1;
 			roccat_report_event(pyra->chrdev_minor,
 					(uint8_t const *)&roccat_report,
 					sizeof(struct pyra_roccat_report));
-- 
1.7.2.2



