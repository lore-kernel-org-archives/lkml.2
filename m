Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab1ERPP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:15:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab1ERPP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:15:56 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=nZMiEFGSWTUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=lM3pySNg2ZzetFUrtWIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: correct how RT task is picked
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <BANLkTinzsjTy6yA7N-ssy5beyJn5NQZX3w@mail.gmail.com>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
	 <BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
	 <BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
	 <20110512120606.GA3639@zhy> <20110518013842.GD23940@home.goodmis.org>
	 <BANLkTikOW9t6F8jvTJ0uPvyYDy+mpXh-DA@mail.gmail.com>
	 <BANLkTikMdAG4HFmhiB9c3x97FH0N3PnpHA@mail.gmail.com>
	 <1305725044.26849.11.camel@gandalf.stny.rr.com>
	 <BANLkTinzsjTy6yA7N-ssy5beyJn5NQZX3w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 18 May 2011 11:15:54 -0400
Message-ID: <1305731754.11267.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 22:46 +0800, Hillf Danton wrote:

> For migration, it is the case that cpu != rq->cpu, and
> if cpu is allowed by task's affinity, it is bug that task
> could not goto cpu because of nr_cpus_allowed since
> the nr_cpus_allowed is computed based on the cpus_allowed mask.

Right, that nr_cpus_allowed was to be a short cut, so we did not have to
look at the cpu mask. But as that check came after, it was pointless.
Perhaps that too was a relic with the cpu < 0 case.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


