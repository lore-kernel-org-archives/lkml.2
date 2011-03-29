Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1C2MtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:49:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab1C2MtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:49:05 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=D48tj3hmCtUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=DDJ3mrVtAAAA:8 a=_lhN5bRkVMF5Vi1OfOkA:9 a=WEVemJ1CzUeo4M41oMCiseDMZPcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Steven Rostedt <rostedt@goodmis.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <201103290430.p2T4UhLA081016@www262.sakura.ne.jp>
References: <201103261312.AEJ01293.OVFJFSLtHOFOMQ@I-love.SAKURA.ne.jp>
	 <20110328171217.GA8529@home.goodmis.org>
	 <201103290430.p2T4UhLA081016@www262.sakura.ne.jp>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 29 Mar 2011 08:49:02 -0400
Message-ID: <1301402942.14261.266.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 13:30 +0900, Tetsuo Handa wrote:
> I made a small test module (which should work on 2.6.38.2).

Thanks! I'll take a look at this later today.
> 
> ---------- locktest.c start ----------
[...]
> ---------- Makefile end ----------
> 
> Below are my testcases and results (gcc 3.3 / x86_32).
> Kernel config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.38.2 .
> 
> ---------- Testcase 1 ----------
> 
> # cat /proc/locktest1
> # cat /proc/locktest2
> # cat /proc/locktest1
> # cat /proc/locktest2
> # cat /proc/locktest1
> # cat /proc/locktest2
> 
> showed nothing in dmesg.
> 
> ---------- Testcase 2 ----------
> 
> # cat /proc/locktest1
> # cat /proc/locktest2
> # cat /proc/locktest3
> 
> showed below message.
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.38.2 #1
> -------------------------------------------------------

[...]

> Well... did I misuse spinlock primitives in read_seqbegin2()?
> Anyway, lockdep should catch testcase 1.

Strange. I'll investigate this further.

Thanks,

-- Steve


