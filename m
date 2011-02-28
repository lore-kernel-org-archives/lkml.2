Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab1B1QJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:09:16 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:36478 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1B1QJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:09:15 -0500
Date: Mon, 28 Feb 2011 11:08:50 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Pierre Tardy <tardyp@gmail.com>
Cc: linux-pm@lists.linux-foundation.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_idle: disable NHM/WSM HW C-state auto-demotion (v3)
In-reply-to: <AANLkTinVCvUkmX3pnSy_Ah3fOm6hV-jAPrQXAQ971xnS@mail.gmail.com>
Message-id: <alpine.LFD.2.02.1102281105460.17782@x980>
References: <alpine.LFD.2.02.1101182150400.14668@x980>
 <alpine.LFD.2.02.1101190035200.14668@x980>
 <alpine.LFD.2.02.1102160119430.843@x980>
 <AANLkTinVCvUkmX3pnSy_Ah3fOm6hV-jAPrQXAQ971xnS@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hardware C-state auto-demotion is a mechanism where the HW overrides
> > the OS C-state request, instead demoting to a shallower state,
> > which is less expensive, but saves less power.

> I'm interrested, for pytimechart, to have trace information of what
> actual c-state got reached after each idle request.
> Do you have any info on how to get that?

the actual c-state residency can be seen in the residency 
counters that are exported by turbostat.
However, at the time of the request/return the OS doesn't know
that it's request got demoted demoted (or un-demoted).

No, checking the counters is not something we want to
add to the idle entry/exit path -- they are not optimized for speed.

thanks,
Len Brown, Intel Open Source Technology Center

