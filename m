Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0LHBK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:10:27 -0500
Received: from kroah.org ([198.145.64.141]:33826 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838Ab0LHBDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:51 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:47 2010
Message-Id: <20101208005747.312069308@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [259/289] wmi: use memcmp instead of strncmp to compare GUIDs
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

commit 8b14d7b22c61f17ccb869e0047d9df6dd9f50a9f upstream.

While looking for the duplicates in /sys/class/wmi/, I couldn't find
them. The code that looks for duplicates uses strncmp in a binary GUID,
which may contain zero bytes. The right function is memcmp, which is
also used in another section of wmi code.

It was finding 49142400-C6A3-40FA-BADB-8A2652834100 as a duplicate of
39142400-C6A3-40FA-BADB-8A2652834100. Since the first byte is the fourth
printed, they were found as equal by strncmp.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -801,7 +801,7 @@ static bool guid_already_parsed(const ch
 		wblock = list_entry(p, struct wmi_block, list);
 		gblock = &wblock->gblock;
 
-		if (strncmp(gblock->guid, guid_string, 16) == 0)
+		if (memcmp(gblock->guid, guid_string, 16) == 0)
 			return true;
 	}
 	return false;


