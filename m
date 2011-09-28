Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1I1Wij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab1I1Wig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:25 2011
Message-Id: <20110928220125.322280930@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nishanth Aravamudan <nacc@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Fabio M. Di Nitto" <fdinitto@redhat.com>
Subject: [001/244] kernel/printk: do not turn off bootconsole in printk_late_init() if keep_bootcon
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nishanth Aravamudan <nacc@us.ibm.com>

commit 4c30c6f566c0989ddaee3407da44751e340a63ed upstream.

It seems that 7bf693951a8e ("console: allow to retain boot console via
boot option keep_bootcon") doesn't always achieve what it aims, as when
printk_late_init() runs it unconditionally turns off all boot consoles.
With this patch, I am able to see more messages on the boot console in
KVM guests than I can without, when keep_bootcon is specified.

I think it is appropriate for the relevant -stable trees.  However, it's
more of an annoyance than a serious bug (ideally you don't need to keep
the boot console around as console handover should be working -- I was
encountering a situation where the console handover wasn't working and
not having the boot console available meant I couldn't see why).

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>
Acked-by: Fabio M. Di Nitto <fdinitto@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1584,7 +1584,7 @@ static int __init printk_late_init(void)
 	struct console *con;
 
 	for_each_console(con) {
-		if (con->flags & CON_BOOT) {
+		if (!keep_bootcon && con->flags & CON_BOOT) {
 			printk(KERN_INFO "turn off boot console %s%d\n",
 				con->name, con->index);
 			unregister_console(con);


