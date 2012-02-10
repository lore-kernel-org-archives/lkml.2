Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab2BJNm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:42:28 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:46424 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab2BJNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:42:27 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] firewire-sbp2: Various fixes
Date: Fri, 10 Feb 2012 13:41:51 +0000
Message-Id: <1328881314-26544-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net>
References: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net

