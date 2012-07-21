Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab2GUGmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 02:42:43 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:41311 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab2GUGmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 02:42:42 -0400
MIME-Version: 1.0
In-Reply-To: <201207202144.05154.rjw@sisk.pl>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342808550.2583.48.camel@twins> <20120720183400.GL32763@google.com> <201207202144.05154.rjw@sisk.pl>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Sat, 21 Jul 2012 12:12:13 +0530
Message-ID: <CAMQu2gy0OtMaYZzPwJqO+VbVbd_y-cCE8sXowrhmqWWxzimu=g@mail.gmail.com>
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle workers
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Sat, Jul 21, 2012 at 1:14 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, July 20, 2012, Tejun Heo wrote:
>> Hello,
>>
>> On Fri, Jul 20, 2012 at 08:22:30PM +0200, Peter Zijlstra wrote:
>> > I really think people who use hotplug at high frequencies are on drugs
>> > and doing it wrong.
>>
>> I don't know.  It does make some sense.  It's not like we have any
>> other mechanism to keep some processors completely quiesient, which
>> could make a noticeable difference from powersaving POV compared to
>> mostly idle.  Rafael, can you please chime in and explain how / where
>> / how freqeuntly / etc CPU hotplug is used for powersaving?
>
> Well, there are use cases I'm not really familiar with.
>
> Pretty much the only use case I'm sufficiently familiar with is
> suspend/hibernate where we unplug all of the nonboot CPUs at one point.
>
> The other use cases, which I don't really think are entirely valid,
> are on some ARM platforms where CPUs are unplugged instead of being put into
> C-states or equivalent (because we don't have a good mechanism for handling
> multiprocessor C-states; there's a set of patches for that waiting for
> the merge window in the Len's tree).  I'm hoping to get rid of those
> use cases in future entirely.
>
Not sure if you are talking about couple idle series waiting in Len's tree for
the merge.

That series actually trying add infrastructure for the hardwares
where CPU's need co-ordination which is needed on few ARM hardwares
to get into deeper CPU cluster C-states. It is indeed true that without
that approach, cpu-hotplug was used to overcome the ordering issue
I guess Exynos, Tegra and OMAP are the few ARM architectures I
know who has been using the couple cpuidle infrastructure.

Regards
Santosh
Regards
Santosh
