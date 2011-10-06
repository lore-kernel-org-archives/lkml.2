Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab1JFUCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 16:02:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38081 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1JFUCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 16:02:01 -0400
Date: Thu, 6 Oct 2011 15:01:55 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: joeyli <jlee@suse.com>, Matthew Garrett <mjg@redhat.com>
Cc: Joey Lee <jlee@novell.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acer-wmi: Add wireless quirk for Lenovo 3000 N200
Message-ID: <20111006200155.GI29557@thinkpad-t410>
Mail-Followup-To: joeyli <jlee@suse.com>, Matthew Garrett <mjg@redhat.com>,
	Joey Lee <jlee@novell.com>, platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1317756778-11822-1-git-send-email-seth.forshee@canonical.com>
 <1317890314.11626.115.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317890314.11626.115.camel@linux-s257.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 04:38:34PM +0800, joeyli wrote:
> Simple applied and tested on my acer machine, no problem!
> 
> Reviewed-by: Lee, Chun-Yi <jlee@novell.com>

Thanks, Joey!

Matthew, I just realized that I got the wrong bug number in the
description. Could you take the version below instead? It's identical
except for the bug number. Thanks!


>From ddaa90fce02f0aaaaa4fd3308f3a86fbe522bb86 Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Wed, 28 Sep 2011 13:12:52 -0500
Subject: [PATCH] acer-wmi: Add wireless quirk for Lenovo 3000 N200

This quirk fixes the wlan rfkill status on this machine. Without
it, wlan is permanently soft blocked whenever acer-wmi is loaded.

BugLink: https://bugs.launchpad.net/bugs/857297
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/acer-wmi.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index af2bb20..dac286a 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -464,6 +464,15 @@ static struct dmi_system_id acer_quirks[] = {
 		},
 		.driver_data = &quirk_lenovo_ideapad_s205,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Lenovo 3000 N200",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "0687A31"),
+		},
+		.driver_data = &quirk_fujitsu_amilo_li_1718,
+	},
 	{}
 };
 
-- 
1.7.4.1

