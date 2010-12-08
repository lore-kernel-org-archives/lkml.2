Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab0LHBEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:04:04 -0500
Received: from kroah.org ([198.145.64.141]:33846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854Ab0LHBD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:56 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:47 2010
Message-Id: <20101208005747.836255393@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [264/289] Input: i8042 - add Sony VAIO VPCZ122GX to nomux list
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[Note that the mainline will not have this particular fix but rather
will blacklist entire VAIO line based off DMI board name. For stable
I am being a bit more cautious and blacklist one particular product.]

Trying to query/activate active multiplexing mode on this VAIO makes
both keyboard and touchpad inoperable. Futher kernels will blacklist
entire VAIO line, however here we blacklist just one particular model.

Reported-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -333,6 +333,13 @@ static const struct dmi_system_id __init
 		},
 	},
 	{
+		/* Sony Vaio VPCZ122GX */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VPCZ122GX"),
+		},
+	},
+	{
 		/* Sony Vaio FS-115b */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),


