Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2DCHqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:46:51 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:43727 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751562Ab2DCHqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:46:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@kernel.org>
Cc: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
	<20120402165036.2bc987ad@pluto.restena.lu>
	<m17gxyklfm.fsf@fess.ebiederm.org> <20120402213440.49e9de74@neptune>
	<1333401898.2960.78.camel@laptop> <1333403193.2960.80.camel@laptop>
	<20120403060252.GA27084@gmail.com>
	<20120403081735.78ca3bb3@pluto.restena.lu>
	<m1d37pgugy.fsf@fess.ebiederm.org> <20120403071543.GA17502@gmail.com>
Date: Tue, 03 Apr 2012 00:50:33 -0700
In-Reply-To: <20120403071543.GA17502@gmail.com> (Ingo Molnar's message of
	"Tue, 3 Apr 2012 09:15:43 +0200")
Message-ID: <m1r4w5dzjq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/mnvVGYcIEYfM2kMCuZhFPxyBAA9SlIsc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@kernel.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> Bruno Prémont <bonbons@linux-vserver.org> writes:
>> 
>> > Prevent kernel from crashing when a device is being registered with sysfs
>> > but has no (aka NULL) group attributes, but warn about it so calling path
>> > can get fixed.
>> 
>> The idea is reasonable but the implementation is horrible.
>> 
>> >> Will do - but the underlying generic bug should be fixed as 
>> >> well: we must not crash just because some attributes are missing 
>> >> in a rarely used sub-driver ...
>> >> 
>> >> We should WARN_ON(), etc. - but not crash.
>> 
>> FIX perf to include sanity checks.
>
> Huh, so put repeated, duplicated, inconsistently applied sanity 
> checks into dozens of sysfs attribute using kernel subsystems?
>
> Major FAIL, dude.


> Eric's rant about putting sanit checks at every usage site is 
> just crazy talk.

No.  I was not talking about every usage site.  I was talking about the
sites that are don't have a direct call chain to the sysfs methods and
instead do something clever that makes backtraces worthless.

In the normal case sysfs registration problems are simple to trace
back to their source because the backtrace points a finger at
the piece of code that when registering had a problem.

Unfortunately perf is built differently.  perf seems to be built to hide
who the idiot was who registered the wrong piece of code and despite
having a perfectly good backtrace and knowing it was perf the person
reporting the original bug still was going to need to do a bisect to
find the real culprit of the problem.

So I am asking that since perf is built in a way that actively makes
debugging these kinds of problems hard that you please add additional
debugging code to perf_pmu_register or some other better location so
that simply registering something buggy with perf will show the bug.

Either that or please fix perf events so that a backtrace is worth
something.

Thanks,
Eric
