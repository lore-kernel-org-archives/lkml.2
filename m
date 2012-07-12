Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161777Ab2GLXfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:35:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab2GLWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:39:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Igor Murzov <intergalactic.anonymous@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [ 075/187] ACPI video: Still use ACPI backlight control if _DOS doesnt exist
Date: Thu, 12 Jul 2012 15:33:51 -0700
Message-Id: <20120712191529.373756326@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit b03738430c7537d5f87948e0b35d8aaf2688c6b4 upstream.

This fixes a regression in 3.4-rc1 caused by commit
ea9f8856bd6d4ed45885b06a338f7362cd6c60e5
(ACPI video: Harden video bus adding.)

Some platforms don't have _DOS control method, but the ACPI
backlight still works.
We should not invoke _DOS for these platforms.

https://bugzilla.kernel.org/show_bug.cgi?id=43168

Cc: Igor Murzov <intergalactic.anonymous@gmail.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -558,6 +558,8 @@ acpi_video_bus_DOS(struct acpi_video_bus
 	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
 	struct acpi_object_list args = { 1, &arg0 };
 
+	if (!video->cap._DOS)
+		return 0;
 
 	if (bios_flag < 0 || bios_flag > 3 || lcd_flag < 0 || lcd_flag > 1)
 		return -EINVAL;


