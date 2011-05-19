Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019Ab1ESSUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:20:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40474 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933966Ab1ESSIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:24 -0400
X-Sasl-enc: t7aaGEx+/t8m4vYDbbrq+1qsK2NR9UNViYWxn5eun9k7 1305828503
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:56 2011
Message-Id: <20110519180556.893385066@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [27/71] PM / Hibernate: Fix ioctl SNAPSHOT_S2RAM
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 36cb7035ea0c11ef2c7fa2bbe0cd181b23569b29 upstream.

The SNAPSHOT_S2RAM ioctl used for implementing the feature allowing
one to suspend to RAM after creating a hibernation image is currently
broken, because it doesn't clear the "ready" flag in the struct
snapshot_data object handled by it.  As a result, the
SNAPSHOT_UNFREEZE doesn't work correctly after SNAPSHOT_S2RAM has
returned and the user space hibernate task cannot thaw the other
processes as appropriate.  Make SNAPSHOT_S2RAM clear data->ready
to fix this problem.

Tested-by: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/power/user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -381,6 +381,7 @@ static long snapshot_ioctl(struct file *
 		 * PM_HIBERNATION_PREPARE
 		 */
 		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		data->ready = 0;
 		break;
 
 	case SNAPSHOT_PLATFORM_SUPPORT:


