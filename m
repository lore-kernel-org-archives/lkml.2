Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab1FAINw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:13:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab1FAINr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:13:47 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:50 2011
Message-Id: <20110601080349.089622609@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:20 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [084/146] staging: r8712u: Fix driver to support ad-hoc mode
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Chua <jeff.chua.linux@gmail.com>

commit 62819fd9481021db7f87d5f61f2e2fd2be1dfcfa upstream.

Driver r8712u is unable to handle ad-hoc mode. The issue is that when
the driver first starts, there will not be an SSID for association.
The fix is to always call the "select and join from scan" routine when
in ad-hoc mode.

Note: Ad-hoc mode worked intermittently before. If the driver had
previously been associated, then things were OK.

Signed-off-by: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8712/rtl871x_ioctl_set.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
@@ -68,7 +68,10 @@ static u8 do_join(struct _adapter *padap
 	pmlmepriv->fw_state |= _FW_UNDER_LINKING;
 	pmlmepriv->pscanned = plist;
 	pmlmepriv->to_join = true;
-	if (_queue_empty(queue) == true) {
+
+	/* adhoc mode will start with an empty queue, but skip checking */
+	if (!check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) &&
+	    _queue_empty(queue)) {
 		if (pmlmepriv->fw_state & _FW_UNDER_LINKING)
 			pmlmepriv->fw_state ^= _FW_UNDER_LINKING;
 		/* when set_ssid/set_bssid for do_join(), but scanning queue


