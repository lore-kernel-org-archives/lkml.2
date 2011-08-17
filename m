Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1HQGOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 02:14:44 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:43624 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab1HQGOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 02:14:41 -0400
Message-ID: <4E4B5C4E.1070707@gmail.com>
Date: Tue, 16 Aug 2011 23:14:38 -0700
From: Da Zheng <zhengda1936@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.5; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: some confusion in timekeeping
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I try to understand the code in kernel/time/timekeeping.c, but it's very
confusing. The most confusing part is shift. I don't understand why we need
that? I notice that (clocksource.mult >> clocksource.shift) is the number of
nanoseconds for each cycle, but I don't see a point why shift should be used.
For example, the code below makes no sense to me. If clock->mult is the number
of nanoseconds for a cycle, then we don't need to shift `tmp'.
        tmp = NTP_INTERVAL_LENGTH;
        tmp <<= clock->shift;
        ntpinterval = tmp;
        tmp += clock->mult/2;
        do_div(tmp, clock->mult);

clocksource_jiffies uses 8 as the shift value, but I don't know why it is
chosen. clocks_calc_mult_shift() is used to calculate shift and mult, but I
don't understand how the algorithm works there. It seems there is very few
documents about timekeeping.c

Can anyone help me understand the code or point me to some documents?

Thanks a lot,
Da
