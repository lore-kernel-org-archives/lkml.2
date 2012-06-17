Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2FQUJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab2FQUJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:09:38 -0400
Date: Sun, 17 Jun 2012 16:09:31 -0400
From: Dave Jones <davej@redhat.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: missing leap second patches in stable.
Message-ID: <20120617200931.GA19482@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	John Stultz <john.stultz@linaro.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
References: <20120615152007.GA11793@redhat.com>
 <4FDB8382.8090501@linaro.org>
 <20120615190958.GA9864@redhat.com>
 <20120616055007.GA5808@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616055007.GA5808@netboy.at.omicron.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 07:50:09AM +0200, Richard Cochran wrote:
 > On Fri, Jun 15, 2012 at 03:09:59PM -0400, Dave Jones wrote:
 > > On Fri, Jun 15, 2012 at 11:48:34AM -0700, John Stultz wrote:
 > >  > On 06/15/2012 08:20 AM, Dave Jones wrote:
 > >  > > Should these be in -stable ? Looks like all the other recent changes
 > >  > > in that area are present.  With the leap second just two weeks away,
 > >  > > it seems like they should be.
 > >  > >
 > >  > > Looks like 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d is in 3.4-stable,
 > >  > > (haven't checked earlier -stable trees).
 > >  > 
 > >  > So the second patch has been sent out for stable review as of yesterday. 
 > >  > So it should be on its way, but you're right that I forgot to CC stable 
 > >  > on the first TAI offset fix.
 > >  > 
 > >  > I'll generate the patch and send it to Greg.  Thanks for the close 
 > >  > review here!
 > > 
 > > fwiw, I did a test on 3.5rc2 yesterday where I forced a fake leap second at midnight.
 > > Nothing untoward happened, unlike the previous ones :-)
 > 
 > Out of curiosity, how do you test that? Do you have any programs
 > specifically for testing the leap second issue?

no, I just patched the kernel to do this..

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 70b33ab..5f4a1f0 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -396,6 +396,13 @@ int second_overflow(unsigned long secs)
 
 	spin_lock_irqsave(&ntp_lock, flags);
 
+	if (time_state == TIME_OK) {
+		if (secs % 86400 == 0) {
+			printk("Faking leap second.\n");
+			time_state = TIME_INS;
+		}
+	}
+
 /*
  * Leap second processing. If in leap-insert state at the end of the
  * day, the system clock is set back one second; if in leap-delete


and then waited until midnight UTC, and then..

[68242.572516] Faking leap second.
[68242.573379] Clock: inserting leap second 23:59:60 UTC

	Dave

