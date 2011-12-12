Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1LLXxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:53:09 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:32970 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1LLXxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:53:04 -0500
Message-ID: <1323733973.4078.116.camel@work-vm>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
From: john stultz <johnstul@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 12 Dec 2011 15:52:53 -0800
In-Reply-To: <CAObL_7H_2H3f=+UwJ_DEGAVYbQY_ekj+a+BQf6qyFrtU4mqnAw@mail.gmail.com>
References: <1323718578-1157-1-git-send-email-asharma@fb.com>
	 <1323718578-1157-3-git-send-email-asharma@fb.com>
	 <1323731361.4078.102.camel@work-vm> <4EE68C31.1030207@fb.com>
	 <1323732772.4078.113.camel@work-vm>
	 <CAObL_7H_2H3f=+UwJ_DEGAVYbQY_ekj+a+BQf6qyFrtU4mqnAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121223-1780-0000-0000-000001955AD7
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000240; HX=3.00000179; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00095590; UDB=6.00024989; UTC=2011-12-12
 23:53:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 15:41 -0800, Andrew Lutomirski wrote:
> On Mon, Dec 12, 2011 at 3:32 PM, john stultz <johnstul@us.ibm.com> wrote:
> > Is it just that you're concerned about the clockid switch costs being
> > too high?
> 
> From my (old, from memory) measurements, the switch cost is very very
> low if it's predicted correctly, and the main case where it's likely
> to be mispredicted is when it hasn't been called in awhile, in which
> case either probably no one cares or the cache misses will dominate.
> 
> How worried are you about introducing a year 2554 bug?  Python says:
> 
> >>> dateutil.parser.parse('1/1/1970') + datetime.timedelta(seconds = 2**64 // 1000000000)
> datetime.datetime(2554, 7, 21, 23, 34, 33)

Not very. :) 

Worse case the syscall can expose a nsec_t or something that can be
bumped to u128 when that becomes common.

thanks
-john

