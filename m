Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab1HCXfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:35:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab1HCXae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:54 2011
Message-Id: <20110803221254.271851712@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:02:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [101/102] dm mpath: fix potential NULL pointer in feature arg processing
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 286f367dad40beb3234a18c17391d03ba939a7f3 upstream.

Avoid dereferencing a NULL pointer if the number of feature arguments
supplied is fewer than indicated.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-mpath.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -807,6 +807,11 @@ static int parse_features(struct arg_set
 	if (!argc)
 		return 0;
 
+	if (argc > as->argc) {
+		ti->error = "not enough arguments for features";
+		return -EINVAL;
+	}
+
 	do {
 		param_name = shift(as);
 		argc--;


