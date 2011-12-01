Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab1K3LJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:09:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61381 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1K3LJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:09:20 -0500
Message-ID: <4ED6C5CE.2030105@gmail.com>
Date: Wed, 30 Nov 2011 19:09:50 -0500
From: "Yang Honggang(Joseph)" <ganggexiongqi@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: johnstul@us.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: clocksource.c "margin"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John Stultz,
I'm very sorry to trouble you. A problem puzzled me when I reading your 
code in kernel/time/clocksource.c.
In the following functions, your said in the comments that >>5 was used 
to leave a margin of 12.5%.
I don't know how to get the result. I think is should be >> 3 in order 
to leave a margin of 12.5%.
The operation of >> 5 only left 3.125% margin.

__clocksource_updatefreq_scale
...
sec = (cs->mask - (cs->mask >> 5));
...
clocksource_max_deferment
...
     /*
      * To ensure that the clocksource does not wrap whilst we are idle,
      * limit the time the clocksource can be deferred by 12.5%. Please
      * note a margin of 12.5% is used because this can be computed with
      * a shift, versus say 10% which would require division.
      */
     return max_nsecs - (max_nsecs >> 5);
...

Best regards,
Joseph
