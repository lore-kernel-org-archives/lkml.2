Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab1IISIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:08:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46536 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439Ab1IISIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:08:04 -0400
Date: Fri, 9 Sep 2011 11:07:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Sung <penmount.touch@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Input: penmount - add PenMount 6250 support
Message-ID: <20110909180758.GE32383@core.coreip.homeip.net>
References: <1315555667-5893-1-git-send-email-penmount.touch@gmail.com>
 <1315555667-5893-3-git-send-email-penmount.touch@gmail.com>
 <20110909180419.GC32383@core.coreip.homeip.net>
 <20110909180637.GD32383@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909180637.GD32383@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 11:06:37AM -0700, Dmitry Torokhov wrote:
> On Fri, Sep 09, 2011 at 11:04:19AM -0700, Dmitry Torokhov wrote:
> > On Fri, Sep 09, 2011 at 04:07:47PM +0800, John Sung wrote:
> > > Add multi touch support for PenMount 6250 touch controller.
> > > 
> > 
> > Given the changes to previous patches, this one turns into:
> > 
> 
> Also, I wonder if we should do something like this:
> 

And if you could give this patch a try that would be great.

Thank you.

-- 
Dmitry


Input: penmount - simplify unregister procedure

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Since touchscreen driver does not handle any events to be sent to the
device we can close serio port first and then unregister the input device.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/penmount.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index 7ebed38..618385e 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -183,12 +183,12 @@ static void pm_disconnect(struct serio *serio)
 {
 	struct pm *pm = serio_get_drvdata(serio);
 
-	input_get_device(pm->dev);
-	input_unregister_device(pm->dev);
 	serio_close(serio);
-	serio_set_drvdata(serio, NULL);
-	input_put_device(pm->dev);
+
+	input_unregister_device(pm->dev);
 	kfree(pm);
+
+	serio_set_drvdata(serio, NULL);
 }
 
 /*
