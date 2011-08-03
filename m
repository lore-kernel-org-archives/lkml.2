Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab1HCXbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:31:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234Ab1HCXab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:54 2011
Message-Id: <20110803221254.165992347@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:02:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [100/102] dm snapshot: flush disk cache when merging
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 762a80d9fc9f690a3a35983f3b4619a220650808 upstream.

This patch makes dm-snapshot flush disk cache when writing metadata for
merging snapshot.

Without cache flushing the disk may reorder metadata write and other
data writes and there is a possibility of data corruption in case of
power fault.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap-persistent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -753,7 +753,7 @@ static int persistent_commit_merge(struc
 	for (i = 0; i < nr_merged; i++)
 		clear_exception(ps, ps->current_committed - 1 - i);
 
-	r = area_io(ps, WRITE);
+	r = area_io(ps, WRITE_FLUSH_FUA);
 	if (r < 0)
 		return r;
 


