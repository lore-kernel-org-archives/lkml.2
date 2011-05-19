Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab1ESSHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:07:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57427 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933751Ab1ESSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:43 -0400
X-Sasl-enc: jwqfUe7QslZeb4gHIXINXx9ES+ELHY/I1mZdWnQj6MIl 1305828462
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:54 2011
Message-Id: <20110519180554.677638336@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [04/71] cifs: refactor mid finding loop in cifs_demultiplex_thread
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 146f9f65bd13f56665205aed7205d531c810cb35 upstream.

...to reduce the extreme indentation. This should introduce no
behavioral changes.

Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |   92 +++++++++++++++++++++++++++---------------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -618,59 +618,59 @@ incomplete_rcv:
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 
-			if ((mid_entry->mid == smb_buffer->Mid) &&
-			    (mid_entry->midState == MID_REQUEST_SUBMITTED) &&
-			    (mid_entry->command == smb_buffer->Command)) {
-				if (length == 0 &&
-				   check2ndT2(smb_buffer, server->maxBuf) > 0) {
-					/* We have a multipart transact2 resp */
-					isMultiRsp = true;
-					if (mid_entry->resp_buf) {
-						/* merge response - fix up 1st*/
-						if (coalesce_t2(smb_buffer,
+			if (mid_entry->mid != smb_buffer->Mid ||
+			    mid_entry->midState != MID_REQUEST_SUBMITTED ||
+			    mid_entry->command != smb_buffer->Command) {
+				mid_entry = NULL;
+				continue;
+			}
+
+			if (length == 0 &&
+			    check2ndT2(smb_buffer, server->maxBuf) > 0) {
+				/* We have a multipart transact2 resp */
+				isMultiRsp = true;
+				if (mid_entry->resp_buf) {
+					/* merge response - fix up 1st*/
+					if (coalesce_t2(smb_buffer,
 							mid_entry->resp_buf)) {
-							mid_entry->multiRsp =
-								 true;
-							break;
-						} else {
-							/* all parts received */
-							mid_entry->multiEnd =
-								 true;
-							goto multi_t2_fnd;
-						}
+						mid_entry->multiRsp = true;
+						break;
+					} else {
+						/* all parts received */
+						mid_entry->multiEnd = true;
+						goto multi_t2_fnd;
+					}
+				} else {
+					if (!isLargeBuf) {
+						/*
+						 * FIXME: switch to already
+						 *        allocated largebuf?
+						 */
+						cERROR(1, "1st trans2 resp "
+							  "needs bigbuf");
 					} else {
-						if (!isLargeBuf) {
-							cERROR(1, "1st trans2 resp needs bigbuf");
-					/* BB maybe we can fix this up,  switch
-					   to already allocated large buffer? */
-						} else {
-							/* Have first buffer */
-							mid_entry->resp_buf =
-								 smb_buffer;
-							mid_entry->largeBuf =
-								 true;
-							bigbuf = NULL;
-						}
+						/* Have first buffer */
+						mid_entry->resp_buf =
+							 smb_buffer;
+						mid_entry->largeBuf = true;
+						bigbuf = NULL;
 					}
-					break;
 				}
-				mid_entry->resp_buf = smb_buffer;
-				mid_entry->largeBuf = isLargeBuf;
+				break;
+			}
+			mid_entry->resp_buf = smb_buffer;
+			mid_entry->largeBuf = isLargeBuf;
 multi_t2_fnd:
-				if (length == 0)
-					mid_entry->midState =
-							MID_RESPONSE_RECEIVED;
-				else
-					mid_entry->midState =
-							MID_RESPONSE_MALFORMED;
+			if (length == 0)
+				mid_entry->midState = MID_RESPONSE_RECEIVED;
+			else
+				mid_entry->midState = MID_RESPONSE_MALFORMED;
 #ifdef CONFIG_CIFS_STATS2
-				mid_entry->when_received = jiffies;
+			mid_entry->when_received = jiffies;
 #endif
-				list_del_init(&mid_entry->qhead);
-				mid_entry->callback(mid_entry);
-				break;
-			}
-			mid_entry = NULL;
+			list_del_init(&mid_entry->qhead);
+			mid_entry->callback(mid_entry);
+			break;
 		}
 		spin_unlock(&GlobalMid_Lock);
 


