Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab1KCCSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:18:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127Ab1KCBde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:33:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:53 2011
Message-Id: <20111102221452.935142934@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [031/107] wireless: Reset beacon_found while updating regulatory
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit aa3d7eef398dd4f29045e9889b817d5161afe03e upstream.

During the association, the regulatory is updated by country IE
that reaps the previously found beacons. The impact is that
after a STA disconnects *or* when for any reason a regulatory
domain change happens the beacon hint flag is not cleared
therefore preventing future beacon hints to be learned.
This is important as a regulatory domain change or a restore
of regulatory settings would set back the passive scan and no-ibss
flags on the channel. This is the right place to do this given that
it covers any regulatory domain change.

Reviewed-by: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/reg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1023,6 +1023,7 @@ static void handle_channel(struct wiphy
 		return;
 	}
 
+	chan->beacon_found = false;
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));


