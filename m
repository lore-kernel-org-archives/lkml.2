Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab0LHBDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:32 -0500
Received: from kroah.org ([198.145.64.141]:33717 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711Ab0LHBD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:29 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:45 2010
Message-Id: <20101208005744.920824815@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Colin Cross <ccross@android.com>, mark <markgross@thegnar.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [235/289] PM / PM QoS: Fix reversed min and max
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Colin Cross <ccross@android.com>

commit 00fafcda1773245a5292f953321ec3f0668c8c28 upstream.

pm_qos_get_value had min and max reversed, causing all pm_qos
requests to have no effect.

Signed-off-by: Colin Cross <ccross@android.com>
Acked-by: mark <markgross@thegnar.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/pm_qos_params.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -120,10 +120,10 @@ static inline int pm_qos_get_value(struc
 
 	switch (o->type) {
 	case PM_QOS_MIN:
-		return plist_last(&o->requests)->prio;
+		return plist_first(&o->requests)->prio;
 
 	case PM_QOS_MAX:
-		return plist_first(&o->requests)->prio;
+		return plist_last(&o->requests)->prio;
 
 	default:
 		/* runtime check for not using enum */


