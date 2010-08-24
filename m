Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232Ab0HXXeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:34:36 -0400
Received: from kroah.org ([198.145.64.141]:40416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497Ab0HXW6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:49 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:15 2010
Message-Id: <20100824224215.340430899@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Patrick LoPresti <lopresti@gmail.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [38/91] dm mpath: fix NULL pointer dereference when path parameters missing
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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
@@ -706,6 +706,7 @@ static struct priority_group *parse_prio
 
 		if (as->argc < nr_params) {
 			ti->error = "not enough path parameters";
+			r = -EINVAL;
 			goto bad;
 		}
 


