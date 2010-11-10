Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab0KJRbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:31:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab0KJRbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:31:12 -0500
Date: Wed, 10 Nov 2010 09:31:38 -0800
From: Greg KH <gregkh@suse.de>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
Message-ID: <20101110173138.GE12371@suse.de>
References: <1289339119.2191.92.camel@laptop> <20101109221338.GA19947@suse.de> <1289345811.10536.8.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289345811.10536.8.camel@concordia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:36:51AM +1100, Michael Ellerman wrote:
> On Tue, 2010-11-09 at 14:13 -0800, Greg KH wrote:
> > On Tue, Nov 09, 2010 at 10:45:19PM +0100, Peter Zijlstra wrote:
> > > The below is a RFC patch adding dynamic type ids to perf.
> > > 
> > > We need to represent PMUs in sysfs because we want to allow multiple
> > > (loadable) PMUs and need a way to identify them.
> > > 
> > > This patch creates a new device class "pmu" and adds a single attribute
> > > "type" to it. This device attribute will expose the dynamic type id as
> > > required by perf_event_attr::type.
> > > 
> > > The sysfs layout looks like:
> > > 
> > > [root@westmere ~]# cd /sys/class/pmu/
> > 
> > You missed the embedded track at Plumbers where we talked about never
> > adding another class to the kernel.  Please use bus_id instead for this.
> 
> At least in the examples I've seen creating a bus requires a lot more
> code than a class. Or is there a shortcut I don't know about when it's a
> virtual bus?
> 
> (Interested because I have code that is using a class)

It shouldn't be that much more code to do so.  Have a pointer to some
code that you want converted over so I can show you exactly what is
needed?

thanks,

greg k-h
