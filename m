Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab2BIJYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:24:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52164 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab2BIJY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:24:27 -0500
Message-ID: <4F33910D.2030409@linaro.org>
Date: Thu, 09 Feb 2012 01:25:33 -0800
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: clock_getres() and real resolution
References: <4F32A347.4090703@linaro.org> <20120209051218.GC2211@netboy.at.omicron.at>
In-Reply-To: <20120209051218.GC2211@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 09:12 PM, Richard Cochran wrote:

> I think "resolution" does not mean tick duration, but rather the finest timer unit.

#include <stdio.h>
#include <time.h>

int main (int argc, char *argv[])
{
   int i;
   struct timespec rs, ts[10];

   clock_getres (CLOCK_REALTIME, &rs);
   printf ("res: %lus %luns\n", rs.tv_sec, rs.tv_nsec);

   for (i = 0; i < 10; i++)
     clock_gettime (CLOCK_REALTIME, ts + i);
   for (i = 0; i < 10; i++)
     printf ("%d: %lus %luns\n", i, ts[i].tv_sec, ts[i].tv_nsec);

   return 0;
}

=>

res: 0s 10000000ns
0: 1328779203s 975317500ns
1: 1328779203s 975317900ns
2: 1328779203s 975318200ns
3: 1328779203s 975318400ns
4: 1328779203s 975318600ns
5: 1328779203s 975318800ns
6: 1328779203s 975319000ns
7: 1328779203s 975319300ns
8: 1328779203s 975319500ns
9: 1328779203s 975319600ns

Old Sun Fire 880, SunOS 5.10 Generic_139555-08.

100ns precision with 10ms "finest timer unit"???

Dmitry
