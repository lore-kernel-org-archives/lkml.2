Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145Ab0HXX0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:26:15 -0400
Received: from kroah.org ([198.145.64.141]:40663 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142Ab0HXW77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:59 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:19 2010
Message-Id: <20100824224219.548337655@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Youn <johnyoun@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [87/91] USB: xhci: Remove buggy assignment in next_trb()
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Youn <John.Youn@synopsys.com>

commit a1669b2c64a9c8b031e0ac5cbf2692337a577f7c upstream.

The code to increment the TRB pointer has a slight ambiguity that could
lead to a bug on different compilers.  The ANSI C specification does not
specify the precedence of the assignment operator over the postfix
operator.  gcc 4.4 produced the correct code (increment the pointer and
assign the value), but a MIPS compiler that one of John's clients used
assigned the old (unincremented) value.

Remove the unnecessary assignment to make all compilers produce the
correct assembly.

Signed-off-by: John Youn <johnyoun@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -125,7 +125,7 @@ static void next_trb(struct xhci_hcd *xh
 		*seg = (*seg)->next;
 		*trb = ((*seg)->trbs);
 	} else {
-		*trb = (*trb)++;
+		(*trb)++;
 	}
 }
 


