Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab1I1WsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:48:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009Ab1I1WsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:46 2011
Message-Id: <20110928220146.560424691@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [201/244] [SCSI] isci: fix event-get pointer increment
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 77cd72a53f6426f81b7f56a862402849ee903bda upstream.

Hardware only increments the put pointer on event types >= 4.  Do not
increment the get pointer for event type 3.

Reported-by: Kapil Karkra <kapil.karkra@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/isci/host.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -531,6 +531,9 @@ static void sci_controller_process_compl
 			break;
 
 		case SCU_COMPLETION_TYPE_EVENT:
+			sci_controller_event_completion(ihost, ent);
+			break;
+
 		case SCU_COMPLETION_TYPE_NOTIFY: {
 			event_cycle ^= ((event_get+1) & SCU_MAX_EVENTS) <<
 				       (SMU_COMPLETION_QUEUE_GET_EVENT_CYCLE_BIT_SHIFT - SCU_MAX_EVENTS_SHIFT);


