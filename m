Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0EYIAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:00:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab0EYIAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:00:09 -0400
Date: Tue, 25 May 2010 10:00:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Stephane Chatty <chatty@enac.fr>, wylda@volny.cz,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, Jerome Vidal <jerom3@free.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] HID: add chardev to propagate special events of
 Roccat hardware to userland
In-Reply-To: <alpine.LNX.2.00.1005250944580.28092@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1005250959150.28092@pobox.suse.cz>
References: <1274288116.2248.3.camel@localhost> <alpine.LNX.2.00.1005250944580.28092@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Jiri Kosina wrote:

> > Module roccat is a char device used to report special events of roccat
> > hardware to userland. 
> 
> I have now applied it.

Plus I had to apply the patch below on top of it.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: roccat: fix build failure if built as module

Fix build failure when roccat and roccat-kone are built as modules.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-roccat.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-roccat.h b/drivers/hid/hid-roccat.h
index 40cca5b..d8aae0c 100644
--- a/drivers/hid/hid-roccat.h
+++ b/drivers/hid/hid-roccat.h
@@ -15,7 +15,7 @@
 #include <linux/hid.h>
 #include <linux/types.h>
 
-#ifdef CONFIG_HID_ROCCAT
+#if defined(CONFIG_HID_ROCCAT) || defined (CONFIG_HID_ROCCAT_MODULE)
 int roccat_connect(struct hid_device *hid);
 void roccat_disconnect(int minor);
 int roccat_report_event(int minor, u8 const *data, int len);

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
