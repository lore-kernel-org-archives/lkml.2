Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab0IXQat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:30:49 -0400
Received: from kroah.org ([198.145.64.141]:38581 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab0IXQ26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:58 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:21 2010
Message-Id: <20100924162621.203022241@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:25:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Islam Amer <pharon@gmail.com>, Kyle McMartin <kyle@mcmartin.ca>
Subject: [72/80] dell-wmi: Add support for eject key on Dell Studio 1555
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Islam Amer <pharon@gmail.com>

commit d5164dbf1f651d1e955b158fb70a9c844cc91cd1 upstream.

Fixes pressing the eject key on Dell Studio 1555 does not work and produces
message :

dell-wmi: Unknown key 0 pressed

Signed-off-by: Islam Amer <pharon@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/dell-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -221,7 +221,7 @@ static void dell_wmi_notify(u32 value, v
 			return;
 		}
 
-		if (dell_new_hk_type)
+		if (dell_new_hk_type || buffer_entry[1] == 0x0)
 			reported_key = (int)buffer_entry[2];
 		else
 			reported_key = (int)buffer_entry[1] & 0xffff;


