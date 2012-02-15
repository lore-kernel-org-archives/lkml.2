Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab2BOO7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:59:21 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:42321 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2BOO7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:59:13 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] firewire-sbp2: Various fixes
Date: Wed, 15 Feb 2012 14:59:07 +0000
Message-Id: <1329317950-101579-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1328881314-26544-1-git-send-email-bootc@bootc.net>
References: <1328881314-26544-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In writing my SBP-2 target code I found a few areas in the firewire-sbp2
initiator code that needed some attention:

1. The Unit_Unique_ID property in SBP-2 unit directories is ignored, but this
   should be used when working out the target port name instead of the node's
   GUID if it is present. (Suggestion of Stefan Richter)

2. The initiator tries to login to any and all SBP-2 targets, including ones on
   the local node. This fails due to how the firewire stack / initiator code
   works but is most likely undesirable behaviour, so this patch makes
   firewire-sbp2 ignore SBP-2 targets on the local node.

3. SBP-2 sends SCSI sense data over the wire in an unusual format which
   requires un-mangling before we can pass it to the SCSI subsystem. Some of
   this mangling is currently being done incorrectly, so this patch fixes it.

Changes since v1:
* Don't fail on malformed Unit_Unique_ID properties, just ignore them
* Just return -ENODEV when we encounter the local node

