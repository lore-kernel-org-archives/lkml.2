Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab1EJTHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:07:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41640 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab1EJTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:07:11 -0400
Subject: Re: [hrtimers] Re: Regression affecting b43 LP-PHY card
From: John Stultz <john.stultz@linaro.org>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: b43-dev <b43-dev@lists.infradead.org>, linux-wireless@vger.kernel.org,
        Juan Carlos Romero <juancarlos.romero@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ben Greear <greearb@candelatech.com>,
        Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTi=Lo4jRWbHhMLkJmOfg09s+ebDjcw@mail.gmail.com>
References: <BANLkTin=cU_kCSFfznna69pkgTsSNVjJgw@mail.gmail.com>
	 <BANLkTi=Lo4jRWbHhMLkJmOfg09s+ebDjcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 12:06:41 -0700
Message-ID: <1305054401.2939.52.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 20:57 +0200, Rafał Miłecki wrote:
> W dniu 10 maja 2011 00:52 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> > In this situation we decided to bisect. I was a little afraid of last
> > merges so we took older 2.6.38 as GOOD (we tested this twice) and
> > wireless-testing commit before my ssb changes as BAD. Today Juan
> > finished bisecting kernel:
> > http://pastebin.com/HSKbRzpB
> >
> > According to his bisection the first bad commit is
> > e06383db9ec591696a06654257474b85bac1f8cb [0]:
> > hrtimers: extend hrtimer base code to handle more then 2 clockids
> >
> > Does it make any sense to you? Could this be some timing issue?
> >
> > It was too late to test this today, we (Juan) will work on this
> > tomorrow. It's impossible to revert this commit from HEAD of
> > wireless-testing, so my idea is to checkout commit, test, revert,
> > test.
> >
> > Did anyone else experience any similar problems with latest wireless-testing?
> >
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e06383db9ec591696a06654257474b85bac1f8cb
> 
> Today Juan checkouted commit e06383db9ec591696a06654257474b85bac1f8cb
> and tested it. He was disconnected really soon.
> 
> Then he reverted e06383db9ec591696a06654257474b85bac1f8cb and tested
> again. Connection was stable, he downloaded 2GB file over network.
> 
> 
> John S.: your commit does not touch Broadcom card directly, but it
> seems it somehow affects it. I suspect there can be some timing issue.
> Do you have any idea what could it be, how can we debug this?

Sorry for the trouble!

My commit exposed a few spots where hrtimers were being initialized
before hrtimer_init is called, which caused problems. Thomas provided a
solution that makes such behavior still function ok:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ce31332d3c77532d6ea97ddcb475a2b02dd358b4

Let me know if the issue is still reproducible with Linus' latest git
tree.

thanks
-john



