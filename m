Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab2D0PXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:23:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48211 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab2D0PXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:23:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120427031013.GA9131@zhy>
References: <CAAcYxUdUBgwuxNKpiXp8r9-aw7+pi7U2E35dnsoL2RD9tf47oQ@mail.gmail.com>
	<20120427031013.GA9131@zhy>
Date: Fri, 27 Apr 2012 08:23:50 -0700
Message-ID: <CAAcYxUdtdVqsGqaZzoiPxP46AX+zcxuSfYgm_D+ShdoB12cs6w@mail.gmail.com>
Subject: Re: High CPU usage of scheduler?
From: Dave Johansen <davejohansen@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 8:10 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>
> On Thu, Apr 26, 2012 at 03:08:51PM -0700, Dave Johansen wrote:
> > I am looking into moving an application from RHEL 5 to RHEL 6 and I
> > noticed an unexpected increase in CPU usage. A little digging has led
> > me to believe that the scheduler may be the culprit.
> >
> > I created the attached test_select_work.c file to test this out. I
> > compiled it with the following command on RHEL 5:
> >
> > cc test_select_work.c -O2 -DSLEEP_TYPE=0 -Wall -Wextra -lm -lpthread
> > -o test_select_work
>
> Hmm...Do both RHEL 5 and RHEL 6 have high resolution timer enabled?
>
> If not, could you please try to boot the one which enable high resolution
> timer with 'highres=off' to see if things change?

Yes, RHEL 6 has CONFIG_HIGH_RES_TIMERS=y. I rebooted and used the
'highres=off' in grub and got the following results:

   ./test_select_work 1000 10000 300 4
   time_per_iteration: min: 3130.1 us avg: 3152.2 us max: 3162.2 us
stddev: 15.0 us
   ./test_select_work 1000 10000 300 8
   time_per_iteration: min: 4314.6 us avg: 4407.9 us max: 4496.3 us
stddev: 60.6 us
   ./test_select_work 1000 10000 300 40
   time_per_iteration: min: 8901.7 us avg: 9056.5 us max: 9121.3 us
stddev: 57.5 us

Any other info that might be helpful?

Thanks,
Dave
