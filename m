Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2IXMEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:04:25 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2208 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798Ab2IXMEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:04:24 -0400
Message-ID: <1348488259.1436.22.camel@x61.thuisdomein>
Subject: x86: "Fast TSC calibration failed" error
From: Paul Bolle <pebolle@tiscali.nl>
To: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Cc: levinsasha928@gmail.com, linux-kernel@vger.kernel.org
Date: Mon, 24 Sep 2012 14:04:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2012 12:04:19.0863 (UTC) FILETIME=[BA5F9270:01CD9A4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) In the dmesg output of the current session of a laptop I noticed:
    <3>[    0.000000] tsc: Fast TSC calibration failed

(Apparently, this calibration succeeds most of the times, because most
previous sessions have "Fast TSC calibration using PIT" in their log.)

1) This message was upgraded to an error in commit
c767a54ba0657e52e6edaa97cbe0b0a8bf1c1655 ("x86/debug: Add KERN_<LEVEL>
to bare printks, convert printks to pr_<level>"). That commit was
included in mainline in v3.6-rc1. Before that commit this message was
printed at default level (ie, as a warning).

2) Why is this message printed as an error?

3) Let's add some background. This message is printed by
quick_pit_calibrate(), which is only called by native_calibrate_tsc().
If it is printed (quick_pit_calibrate() will return 0 and)
native_calibrate_tsc() will try an alternative calibration strategy. But
in that alternative strategy no message ever exceeds warning level, even
if calibration fails.

4) So, without even understanding why tsc calibration is needed, it does
look unnecessary to print "Fast TSC calibration failed" at error level.
If that's correct, I'd be happy to submit the trivial patch to downgrade
it to (say) informational level.


Paul Bolle

