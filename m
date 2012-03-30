Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935543Ab2C3Wd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:33:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935438Ab2C3VJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:09:30 -0400
Message-Id: <20120330194836.228356569@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [ 015/149] staging: r8712u: Fix regression in signal level after commit c6dc001
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit da3e6ec2f443ac00aa623c5921e3521f5f38efe4 upstream.

In commit c6dc001 "staging: r8712u: Merging Realtek's latest (v2.6.6).
Various fixes", the returned qual.qual member of the iw_statistics
struct was changed. For strong signals, this change made no difference;
however for medium and weak signals it results in a low signal that
shows considerable fluctuation, When using wicd for a medium-strength
AP, the value reported in the status line is reduced from 100% to 60% by
this bug.

This problem is reported in https://bugzilla.kernel.org/show_bug.cgi?id=42826.

Reported-and-tested-by: Robert Crawford <wrc1944@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -2380,13 +2380,7 @@ static struct iw_statistics *r871x_get_w
 		tmp_qual = padapter->recvpriv.signal;
 		tmp_noise = padapter->recvpriv.noise;
 		piwstats->qual.level = tmp_level;
-		/*piwstats->qual.qual = tmp_qual;
-		 * The NetworkManager of Fedora 10, 13 will use the link
-		 * quality for its display.
-		 * So, use the fw_rssi on link quality variable because
-		 * fw_rssi will be updated per 2 seconds.
-		 */
-		piwstats->qual.qual = tmp_level;
+		piwstats->qual.qual = tmp_qual;
 		piwstats->qual.noise = tmp_noise;
 	}
 	piwstats->qual.updated = IW_QUAL_ALL_UPDATED;


