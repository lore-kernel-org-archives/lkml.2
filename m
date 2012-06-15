Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2FOTGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:06:01 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43349 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323Ab2FOTF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:05:59 -0400
Message-ID: <4FDB866E.1040504@us.ibm.com>
Date: Fri, 15 Jun 2012 12:01:02 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: Richard Cochran <richardcochran@gmail.com>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
References: <4FDB8563.3030805@us.ibm.com>
In-Reply-To: <4FDB8563.3030805@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061519-7606-0000-0000-000001287A83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 11:56 AM, John Stultz wrote:
> Hey Greg,
>     Forgot to cc stable on this one. Thanks to Dave Jones for noticing!
> -john

Gah. Thunderbird's preformat wrecked that one. Sorry.
Here it is again.
-john

------------------

From: Richard Cochran<richardcochran@gmail.com>

commit dd48d708ff3e917f6d6b6c2b696c3f18c019feed upstream.

When repeating a UTC time value during a leap second (when the UTC
time should be 23:59:60), the TAI timescale should not stop. The kernel
NTP code increments the TAI offset one second too late. This patch fixes
the issue by incrementing the offset during the leap second itself.

Signed-off-by: Richard Cochran<richardcochran@gmail.com>
Signed-off-by: John Stultz<john.stultz@linaro.org>
---
  kernel/time/ntp.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f03fd83..e8c8671 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -412,6 +412,7 @@ int second_overflow(unsigned long secs)
  		if (secs % 86400 == 0) {
  			leap = -1;
  			time_state = TIME_OOP;
+			time_tai++;
  			printk(KERN_NOTICE
  				"Clock: inserting leap second 23:59:60 UTC\n");
  		}
@@ -426,7 +427,6 @@ int second_overflow(unsigned long secs)
  		}
  		break;
  	case TIME_OOP:
-		time_tai++;
  		time_state = TIME_WAIT;
  		break;

-- 
1.7.9.5


