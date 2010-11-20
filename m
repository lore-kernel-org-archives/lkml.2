Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0KTWS1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 17:18:27 -0500
Received: from tomasu.net ([64.85.170.234]:60414 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab0KTWS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 17:18:26 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Konstantin Svist <fry.kun@gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Date: Sat, 20 Nov 2010 15:18:19 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
References: <1287479765.9920.9.camel@marge.simson.net> <1290282678.28711.23.camel@maggy.simson.net> <4CE84578.5030800@gmail.com>
In-Reply-To: <4CE84578.5030800@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011201518.19978.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 20, 2010, you wrote:
> On 11/20/2010 11:51 AM, Mike Galbraith wrote:
> > On Sat, 2010-11-20 at 20:33 +0100, Jesper Juhl wrote:
> >> On Mon, 15 Nov 2010, Linus Torvalds wrote:
> >>> On Mon, Nov 15, 2010 at 2:41 PM,<Valdis.Kletnieks@vt.edu>  wrote:
> >>>> So the set of all tasks that never call proc_set_tty() ends up in the
> >>>> same one big default group, correct?
> >>> 
> >>> Well, yes and no.
> >>> 
> >>> Yes, that's what the code currently does. But I did ask Mike (and he
> >>> delivered) to try to make the code look and work in a way where the
> >>> whole "tty thing" is just one of the heuristics.
> >>> 
> >>> It's not clear exactly what the non-tty heuristics would be, but I do
> >>> 
> >>> have a few suggestions:
> >>>   -  I think it might be a good idea to associate a task group with the
> >>> 
> >>> current "cred" of a process, and fall back on it in the absense of a
> >>> tty-provided one.
> >> 
> >> Or how about (just brainstorming here) a group per 'process group'?
> > 
> > I switched to per session, which on my system at least looks like more
> > than enough granularity
> 
> Will that have an effect on software like Chromium which creates a fork
> for each tab? If a user opens Thunderbird and Chromium with 100 tabs,
> Thunderbird should probably get 50% CPU time instead of just 1%...

At least on my machine, all of the chromium processes have the same session 
id.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
