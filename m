Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab2EXUHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:07:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61632 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909Ab2EXUHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:07:46 -0400
Date: Thu, 24 May 2012 23:07:36 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
Message-ID: <20120524230736.1bc523b9@halley>
In-Reply-To: <4FBE0770.60702@nod.at>
References: <1337608916-49771-1-git-send-email-richard@nod.at>
	<1337608916-49771-2-git-send-email-richard@nod.at>
	<20120522180119.2c2a10a8@pixies.home.jungo.com>
	<4FBBC4EE.4040802@nod.at>
	<1337847472.15137.81.camel@sauron.fi.intel.com>
	<20120524125612.39d3e6aa@halley>
	<4FBE0770.60702@nod.at>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 24 May 2012 12:03:28 +0200 Richard Weinberger <richard@nod.at> wrote:
> On 24.05.2012 11:56, Shmulik Ladkani wrote:
> > Hi Artem,
> >
> > On Thu, 24 May 2012 11:17:52 +0300 Artem Bityutskiy<dedekind1@gmail.com>  wrote:
> >> On Tue, 2012-05-22 at 18:55 +0200, Richard Weinberger wrote:
> >>>>> +    e = find_early_wl_entry(&ubi->free, max_pnum);
> >>>>
> >>>> This picks the eb with the lowest pnum within 'ubi->free'.
> >>>>
> >>>> When called with INT_MAX (for the FM_DATA), why do you need to pick
> >>> a
> >>>> free eb with the minimal pnum? The FM_DATA EBs may reside everywhere
> >>> (as
> >>>> the FM_SB holds their location).
> >>>> So why not pick the eb with a medium EC value (as done for standard
> >>>> get_peb calls)? That might be better wear-leveling wise.
> >>>
> >>> Fair point.
> >>> I'll fix that.
> >>> Artem, any comments on that?
> >>
> >> The 'find_early_wl_entry()' function is used (currently) only at early
> >> stages. At these stages the we do not have the PEBs sorted by EC. We
> >> have just a list. This function should not be use after the WL subsystem
> >> is initialized.
> >
> > 'find_early_wl_entry' is only called from 'ubi_wl_get_fm_peb'.
> 
> Correct.
> 
> > 'ubi_wl_get_fm_peb' is called twice from within 'ubi_update_fastmap':
> > First call, to get the FM_SB, with 'max_pnum' set as UBI_FM_MAX_START.
> > Second, to get FM_DATA pebs, with 'max_pnum' as -1, do indicate "no
> > matter the location, give me pebs from the free pool".
> 
> Correct. Maybe I should rename find_early_wl_entry() to 
> find_wl_entry_for_fastmap() or something like that...

Yes, name is misleading.
How about the ugly but descriptive: find_wl_entry_by_max_pnum?

Regards,
Shmulik
