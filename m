Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1GGLxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:53:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43472 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab1GGLxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:53:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110707085551.GA4718@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
	<20110629201718.GA11071@albatros>
	<20110702073625.GA3318@albatros>
	<CAKTCnzmjaddz-ihxJ_qme28S==BAPGRmC2j3iE5fqm8TPi0knA@mail.gmail.com>
	<20110704174540.GA3321@albatros>
	<20110707085551.GA4718@albatros>
Date: Thu, 7 Jul 2011 17:23:39 +0530
Message-ID: <CAKTCnzn25jUOmefuTPsLwbGGoj5sgz8-CgiV6XO-dMbNuD8Mzg@mail.gmail.com>
Subject: Re: [PATCH 2/2] taskstats: restrict access to user
From: Balbir Singh <bsingharora@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 2:25 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Mon, Jul 04, 2011 at 21:45 +0400, Vasiliy Kulikov wrote:
>> The already known danger is these io fields.
>
> Two more things:
>
> 1) unblocking netlink socket on task exit is a rather useful help to win
> different races.  E.g. if the vulnerable program has the code -
>
>    wait(NULL);
>    do_smth_racy();
>
> - then the attacker's task listening for the taskstats event will be
> effectively woken up just before the racy code.  It might greatly
> increase the chanses to win the race => to exploit the bug.
> (The same defect exists in inotify.)
>

I don't see why taskstats is singled out, please look at proc
notifiers as well. I don't buy this use case, what are we trying to
save here and why is taskstats responsible, because it notifies?

>
> 2) taskstats gives the task information at the precisely specific moment
> - task death.  So, the attacker shouldn't guess whether some event
> occured or not.  The formula of gotten information is _exactly_ task
> activity during the life.  On the contrary, getting the same information
> from procfs files might result in some inaccuracy because of measuring
> time inaccuracy (scheduler's variability, different disks' load, etc.).
>
> Of cource, (2) makes sense only if some sensible information is still
> available through taskstats.

Again this makes no sense to me, at the end we send accumulated data
and that data can be read from /proc/$pid (mostly). The race is that
while I go off to read the data the process might disappear taking all
of its data with it, which is what taskstats tries to solve among
other things. Your use case has a lot of hand waving, which I frankly
cannot put to a logical place in my mind.

Balbir Singh
