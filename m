Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab0EEVyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:54:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41197 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0EEVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:54:05 -0400
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <20100430163538.7253a9e0.sfr@canb.auug.org.au>
	<20100430105016.40b51636.randy.dunlap@oracle.com>
	<20100505091738.7ec27479.randy.dunlap@oracle.com>
	<20100505162459.GA20296@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 May 2010 14:54:00 -0700
In-Reply-To: <20100505162459.GA20296@suse.de> (Greg KH's message of "Wed\, 5 May 2010 09\:24\:59 -0700")
Message-ID: <m18w7y10cn.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: gregkh@suse.de, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, randy.dunlap@oracle.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH] sysfs: Don't use enums in inline function declaration.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It appears gcc can't cope with using an enum that is only declared in
an inline function declaration, that doesn't even use the variable
that is so declared.

Avoid the silliness and replace the enum with an int, and make gcc
happy.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 include/linux/sysfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index e58ca1c..17cbeb7 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -318,7 +318,7 @@ static inline void sysfs_put(struct sysfs_dirent *sd)
 {
 }
 
-static inline void sysfs_exit_ns(enum kobj_ns_type type, const void *tag)
+static inline void sysfs_exit_ns(int type, const void *tag)
 {
 }
 
-- 
1.6.6.1

