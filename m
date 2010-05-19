Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0ESBOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:14:23 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56151 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab0ESBOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:14:21 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@amd64.org>, "Luck\, Tony" <tony.luck@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young\, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       "bluesmoke-devel\@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
References: <4BF18995.6070008@redhat.com> <4BF2392A.9040409@jp.fujitsu.com>
	<4BF2C3D1.10009@redhat.com>
	<1274204560.17703.82.camel@Joe-Laptop.home>
	<20100518185305.GA23921@elte.hu>
	<987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
	<20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org>
	<20100518222832.GJ22675@basil.fritz.box>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 18 May 2010 18:14:09 -0700
In-Reply-To: <20100518222832.GJ22675@basil.fritz.box> (Andi Kleen's message of "Wed\, 19 May 2010 00\:28\:33 +0200")
Message-ID: <m1wrv0zo9q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: andi@firstfloor.org, linux-edac@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net, mingo@elte.hu, joe@perches.com, dougthompson@xmission.com, Matt_Domsch@dell.com, tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org, brent.young@intel.com, mchehab@redhat.com, seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, bp@amd64.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: Hardware Error Kernel Mini-Summit
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> The original motivation to put them somewhere else
> because I was sick of people reporting them as kernel bugs.

This suggests that to get things reported in dmesg I should
setup a cron job that pulls the latest kernel checks to see
if things are reported into syslog and sends you an email
if things are wrong.

I'm not ready to believe the average person that is running linux
is too stupid to understand the difference between a hardware
error and a software error.

> But there's more to it now:
>
>> If your system isn't broken correctable errors are rare.  People look
>
> Actually the more memory you have the more common they are.
> And the trend is to more and more memory.

The error rate should not be fixed per bit but should be roughly fixed
per DIMM.  If the error rate over time is fixed per bit we are in deep
trouble.

> Really to do anything useful with them you need trends
> and automatic actions (like predictive page offlining)

Not at all, and I don't have a clue where you start thinking
predictive page offlining makes the least bit of sense.  Broken
or even weak bits are rarely the common reason for ECC errors.

> A log isn't really a good format for that

A log is a fine format for realizing you have a problem.  A
log doesn't need to be the only place errors are reported
but a log should be the default place ECC errors are reported.
We do that with hard drive errors and other kinds of hardware
errors and we have done it for years without problems.

My experience is that correctable ECC errors come in two kinds of
frequencies.

- The expected single bit correctable error range.  Which is somewhere
  between once a month and once a year per dimm.

  On the most unreasonable configuration I ever worked with. 4TB of ram
  in 1GB sticks up at Los Alomos, at 7000ft in an environment know
  to trigger errors I saw roughly one correctable ECC error an hour.
  Huge but just barely within the expected range.

  I can live with a log message once a month on a mundane system.

- Errors that occur frequently. That is broken hardware of one time or
  another.  I want to know about that so I can schedule down time to replace
  my memory before I get an uncorrected ECC error.  Errors of this kind
  are likely happening frequently enough as to impact performance.

Eric
