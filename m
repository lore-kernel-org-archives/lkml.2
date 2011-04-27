Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab1D0CGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:06:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36564 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1D0CGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:06:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH v2] virtio_balloon: disable oom killer when fill balloon
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <BANLkTikfyi2FBykk1D1H-tdrSjmRYEh6ug@mail.gmail.com>
References: <BANLkTi=8ySUPP6_GUL9CTFh98J1PH0a4=g@mail.gmail.com> <BANLkTikfyi2FBykk1D1H-tdrSjmRYEh6ug@mail.gmail.com>
Message-Id: <20110427110838.D178.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 27 Apr 2011 11:06:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Apr 27, 2011 at 9:37 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > On Wed, Apr 27, 2011 at 7:33 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> >> On Tue, Apr 26, 2011 at 6:39 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >>> On Tue, Apr 26, 2011 at 5:28 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> >>>> Please resend this with [2/2] to linux-mm.
> >>>>
> >>>> On Tue, Apr 26, 2011 at 5:59 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >>>>> When memory pressure is high, virtio ballooning will probably cause oom killing.
> >>>>> Even if alloc_page with GFP_NORETRY itself does not directly trigger oom it
> >>>>> will make memory becoming low then memory alloc of other processes will trigger
> >>>>> oom killing. It is not desired behaviour.
> >>>>
> >>>> I can't understand why it is undesirable.
> >>>> Why do we have to handle it specially?
> >>>>
> >>>
> >>> Suppose user run some random memory hogging process while ballooning
> >>> it will be undesirable.
> >>
> >>
> >> In VM POV, kvm and random memory hogging processes are customers.
> >> If we handle ballooning specially with disable OOM, what happens other
> >> processes requires memory at same time? Should they wait for balloon
> >> driver to release memory?
> >>
> >> I don't know your point. Sorry.
> >> Could you explain your scenario in detail for justify your idea?
> >
> > What you said make sense I understand what you said now. Lets ignore
> > my above argue and see what I'm actually doing.
> >
> > I'm hacking with balloon driver to fit to short the vm migration time.
> >
> > while migrating host tell guest to balloon as much memory as it can, then start
> > migrate, just skip the ballooned pages, after migration done tell
> > guest to release the memory.
> >
> > In migration case oom is not I want to see and disable oom will be good.
> 
> BTW, if oom_killer_disabled is really not recommended to use I can
> switch back to oom_notifier way.

Could you please explain why you dislike oom_notifier and what problem
you faced? I haven't understand why oom_notifier is bad. probably my
less knowledge of balloon is a reason.



