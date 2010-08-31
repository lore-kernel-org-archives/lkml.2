Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0HaV2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:28:07 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46761 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0HaV2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:28:04 -0400
Subject: Re: [PATCH 4/6 v2] HID: magicmouse: remove axis data filtering
From: Chase Douglas <chase.douglas@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Michael Poole <mdpoole@troilus.org>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C7D71B8.4020408@euromail.se>
References: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>
	 <1283280068-12285-4-git-send-email-chase.douglas@canonical.com>
	 <4C7D6739.5000601@euromail.se> <1283288319.2255.103.camel@mini>
	 <4C7D6ECB.2000308@euromail.se> <1283289360.2255.113.camel@mini>
	 <4C7D71B8.4020408@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 17:27:58 -0400
Message-ID: <1283290078.2255.119.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 23:18 +0200, Henrik Rydberg wrote:
> On 08/31/2010 11:16 PM, Chase Douglas wrote:
> 
> > On Tue, 2010-08-31 at 23:06 +0200, Henrik Rydberg wrote:
> >> On 08/31/2010 10:58 PM, Chase Douglas wrote:
> >>
> >>> On Tue, 2010-08-31 at 22:34 +0200, Henrik Rydberg wrote:
> >>>> On 08/31/2010 08:41 PM, Chase Douglas wrote:
> >>>>
> >>>>> The Magic Mouse device is very precise. No driver filtering of input
> >>>>> data needs to be performed.
> >>>>>
> >>>>> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> >>>>> Acked-by: Michael Poole <mdpoole@troilus.org>
> >>>>> ---
> >>>>
> >>>>
> >>>> I am still not sure this is a good idea. Bandwidth from MT devices is a big
> >>>> deal. A statement roughly how much data comes out of mtdev (which does the
> >>>> filtering for type A devices) before and after this change would be reassuring.
> >>>
> >>> As it is right now, hid-magicmouse doesn't support MT slots. I think all
> >>> the fuzz code ends up comparing in the MT case is between one touch and
> >>> another touch, not between one touch's current location and its previous
> >>> location. If I'm correct, then it means a fuzz > 0 is incorrect for
> >>> non-slotted MT devices.
> >>>
> >>> In fact, the code in drivers/input/input.c around line 194 looks like it
> >>> discards defuzzing in this case, so one could say this patch is making
> >>> things more correct :).
> >>
> >>
> >> For type A devices, the filtering is performed in userspace, in mtdev, in the
> >> same manner as it would have been performed in the kernel in the MT slot case.
> >> Therefore, knowing the amount of messages coming out of mtdev is a direct
> >> measurement of the effect of filtering.
> > 
> > Yes, but we're only interested in the kernel driver when reviewing this
> > patch. Leaving the fuzz in as it is has no effect right now on ABS_MT_*
> > axes. On the other axes, such as the touch orientation, it's probably
> > more harmful than good.
> 
> 
> "We" are interested in knowing if this patch makes any sense, given that
> filtering is in actuality performed in userspace, and thus modifying this code
> changes the stream rate into userspace applications, thank you.

Because in-kernel defuzzing is turned off for ABS_MT_* axes on
non-slotted MT devices, there will be no change in the number of events
sent to the userspace due to this patch.

Maybe I'm missing something more fundamental. In which case, I'll need
more details to get it through my dense skull :).

-- Chase

