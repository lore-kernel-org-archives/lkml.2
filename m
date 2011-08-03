Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab1HCXhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:37:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab1HCX3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:29:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:52 2011
Message-Id: <20110803221252.283200933@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alek Du <alek.du@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: [082/102] n_gsm: fix the wrong FCS handling
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Du, Alek" <alek.du@intel.com>

commit f086ced17191fa0c5712539d2b680eae3dc972a1 upstream.

FCS could be GSM0_SOF, so will break state machine...

[This byte isn't quoted in any way so a SOF here doesn't imply an error
 occurred.]

Signed-off-by: Alek Du <alek.du@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
[Trivial but best backported once its in 3.1rc I think]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/n_gsm.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1823,10 +1823,6 @@ static void gsm0_receive(struct gsm_mux
 		break;
 	case GSM_FCS:		/* FCS follows the packet */
 		gsm->received_fcs = c;
-		if (c == GSM0_SOF) {
-			gsm->state = GSM_SEARCH;
-			break;
-		}
 		gsm_queue(gsm);
 		gsm->state = GSM_SSOF;
 		break;


