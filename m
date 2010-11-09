Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0KIWWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:22:25 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59048 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0KIWWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:22:23 -0500
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <AANLkTimb=R0aqtfL=eZpwj=KqJchHU+nhMnjk5ME9BNr@mail.gmail.com>
References: <1289339119.2191.92.camel@laptop>
	 <AANLkTimb=R0aqtfL=eZpwj=KqJchHU+nhMnjk5ME9BNr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 23:22:27 +0100
Message-ID: <1289341347.2191.97.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 23:11 +0100, Kay Sievers wrote:
> On Tue, Nov 9, 2010 at 22:45, Peter Zijlstra <peterz@infradead.org> wrote:
> > The below is a RFC patch adding dynamic type ids to perf.
> >
> > We need to represent PMUs in sysfs because we want to allow multiple
> > (loadable) PMUs and need a way to identify them.
> >
> > This patch creates a new device class "pmu" and adds a single attribute
> > "type" to it. This device attribute will expose the dynamic type id as
> > required by perf_event_attr::type.
> >
> > The sysfs layout looks like:
> >
> > [root@westmere ~]# cd /sys/class/pmu/
> 
> Please use a 'bus_type' instead of 'class'.
> 
> I'm very sure, some day, you'll need global attributes for the pmu
> stuff, and class -- unlike bus -- has its own subdir where you can go
> wild, without mixing things with the list-of-devices. :)

Having its own subdir sounds like a pro, so I'm somewhat confused. Also
the pmu (or event_source as Ingo would like it getting called) seems
like a class of devices not a bus.

USB/PCI/I2C/ISA are all buses.. pmu/event_source not so much, they are
very different (sometimes even pure software) things that provide a
common interface -- they generate events which we can count and sample.

/me dazed & confused, please do explain.

> No new stuff should use 'class', it's not extensible.

Hrm.. when I introduced the bdi stuff class was _the_ thing to use.
