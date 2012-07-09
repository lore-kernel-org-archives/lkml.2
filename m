Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2GIUww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:52:52 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35951 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2GIUwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:52:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: Dilip Daya <dilip.daya@hp.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <1340900320.3441.88.camel@pro6455b.example.com>
	<20120705220749.GA11255@mail.hallyn.com> <87ehopu3e5.fsf@xmission.com>
	<20120706170538.GA31679@mail.hallyn.com> <87fw94g1kq.fsf@xmission.com>
	<20120706194741.GA22113@mail.hallyn.com>
	<87y5ms3bfi.fsf_-_@xmission.com>
Date: Mon, 09 Jul 2012 13:52:43 -0700
In-Reply-To: <87y5ms3bfi.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Mon, 09 Jul 2012 13:51:45 -0700")
Message-ID: <87sjd03bdw.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18tHRXl3CUn4VwHZgEUk7kFOdNSX3RPkVY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: [PATCH 2/2] bonding: debugfs and network namespaces are incompatible
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The bonding debugfs support has been broken in the presence of network
namespaces since it has been added.  The debugfs support does not handle
multiple bonding devices with the same name in different network
namespaces.

I haven't had any bug reports, and I'm not interested in getting any.
Disable the debugfs support when network namespaces are enabled.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/net/bonding/bond_debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bond_debugfs.c
index 3680aa2..2cf084e 100644
--- a/drivers/net/bonding/bond_debugfs.c
+++ b/drivers/net/bonding/bond_debugfs.c
@@ -6,7 +6,7 @@
 #include "bonding.h"
 #include "bond_alb.h"
 
-#ifdef CONFIG_DEBUG_FS
+#if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_NET_NS)
 
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
-- 
1.7.5.4

