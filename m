Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1DDHRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 03:17:49 -0400
Received: from bar.sig21.net ([80.81.252.164]:40886 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab1DDHRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 03:17:48 -0400
X-Greylist: delayed 1316 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Apr 2011 03:17:48 EDT
Message-ID: <4D996B74.4070502@linuxtv.org>
Date: Mon, 04 Apr 2011 08:55:48 +0200
From: Michael Hunold <hunold@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: John Stultz <john.stultz@linaro.org>
Subject: Minimal requirements for RTC drivers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-21-Score: -4.1 (----)
X-Spam-21-Report: No, score=-4.1 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.330,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello John,

I have been working on a new RTC driver for some custom RTC device
lately. It has the usual features like AIE, UIE and PIE.

I cloned the rtc-test.c driver as Documentation/rtc.txt suggested and
noticed that my driver would work with the test application even though
some of the driver functions were not implemented at all...

So I found out about your recent changes with regard to "RTC
virtualisation" and I understood the steps you have taken. It's not
necessary to provide all functionality through the RTC driver directly
any more, because some of the stuff is emulated via hrtimers.

One problem is that the documentation and the code have gotten out of
sync. People like me, who dive into the RTC subsystem for the first
time, can be easily fooled now.

So the main question now is what the minimal required functionality for
a RTC driver now actually is. Can you give me some hints?

I think it would be best if the rtc-test.c driver could be updated to
have a template new drivers can be cloned from.

Another thing that catched my eye is the current use of the read_alarm()
member in struct rtc_class_ops in rtc_read_alarm() in
drivers/rtc/interface.c. This is the only place where the member is used
and it's only used as a boolean there. The driver specific read_alarm()
op is never actually called, so I think that op can be transformed into
a boolean and all the read_alarm() functions from all the rtc drivers
can be removed - that's quite a lot of a code.

Best regards
Michael.
