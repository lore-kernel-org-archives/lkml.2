Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab0HXWx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:53:57 -0400
Received: from kroah.org ([198.145.64.141]:52130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab0HXWxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:53:50 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:24 2010
Message-Id: <20100824222524.325938435@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Patrick LoPresti <lopresti@gmail.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [22/59] dm mpath: fix NULL pointer dereference when path parameters missing
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alasdair G Kergon <agk@redhat.com>

commit 6bbf79a14080a0c61212f53b4b87dc1a99fedf9c upstream.

multipath_ctr() forgets to return an error after detecting
missing path parameters.  Fix this.

Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-mpath.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -691,6 +691,7 @@ static struct priority_group *parse_prio
 
 		if (as->argc < nr_params) {
 			ti->error = "not enough path parameters";
+			r = -EINVAL;
 			goto bad;
 		}
 


