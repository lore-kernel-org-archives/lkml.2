Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab0IZWti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 18:49:38 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44584 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab0IZWth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 18:49:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <m1y6b48973.fsf@fess.ebiederm.org> <20100917205946.GF2522@local>
	<m139t451b4.fsf_-_@fess.ebiederm.org>
	<20100924104555.GC1819@silverbox.local>
	<m1hbhfcbdo.fsf@fess.ebiederm.org>
	<20100924173106.GA4966@silverbox.local>
	<m14ode662q.fsf@fess.ebiederm.org> <20100925003308.GA29910@suse.de>
	<m1wrqa4mg5.fsf@fess.ebiederm.org> <20100926192142.GA7252@kroah.com>
Date: Sun, 26 Sep 2010 15:49:33 -0700
In-Reply-To: <20100926192142.GA7252@kroah.com> (Greg KH's message of "Sun, 26
	Sep 2010 12:21:42 -0700")
Message-ID: <m1d3s086iq.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
Subject: [PATCH 6/5] uio: Fix accidentally changed return value in uio_read
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/uio/uio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index b0032e3..20743aa 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -557,7 +557,7 @@ static ssize_t uio_read(struct file *filep, char __user *buf,
 	if (!idev->info->irq)
 		goto out;
 
-	retval = -EIO;
+	retval = -EINVAL;
 	if (count != sizeof(s32))
 		goto out;
 
-- 
1.7.2.3

