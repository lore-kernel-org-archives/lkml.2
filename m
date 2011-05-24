Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab1EXOMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:12:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1EXOMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:12:21 -0400
Subject: Re: perf: regression -- missing /sys/devices/system/cpu/perf_events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
In-Reply-To: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 May 2011 16:11:46 +0200
Message-ID: <1306246306.18455.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 09:59 -0400, Vince Weaver wrote:
> I know this is a bit late, but for some reason our users sit on these 
> things and then they aren't willing to take it up with linux-kernel 
> themselves
> 
> > > > commit 15ac9a395a753cb28c674e7ea80386ffdff21785
> > > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > Date:   Mon Sep 6 15:51:45 2010 +0200
> > > > 
> > > >    perf: Remove the sysfs bits
> 
> removed the /sys/devices/system/cpu/perf_events
> I thought things in /sys were stable ABI?

if only.. that stuff changes way too often (not to say that's a good
thing).

> Apparently it's common for people to have scripts to check if 
> perf_events is available in a kernel by checking the existence of
> /sys/devices/system/cpu/perf_events, even if they didn't use the
> files within.

A much more reliable way is simply doing the syscall and seeing what
happens. But if you want to poke around in sysfs, /sys/bus/event_source/
is the new location.

> Now that 2.6.38 kernels are starting to hit the distros we're getting 
> complaints that it's missing.

Urgh, they'd been broken long before.. and I hadn't received any
complaints from people about that. I didn't see the point in keeping
broken interfaces around, esp. since with moving to multiple-pmu they
don't make any sense at all.

Ingo, any idea what to do here?
