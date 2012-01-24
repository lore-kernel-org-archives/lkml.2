Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2AXQ0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:26:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:45709 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab2AXQ0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:26:13 -0500
Message-ID: <1327422364.2446.75.camel@twins>
Subject: Re: [RFCv3 0/9] perf tool: parser generator for events parsing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Date: Tue, 24 Jan 2012 17:26:04 +0100
In-Reply-To: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>--suppress-cc=author>
	 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 13:31 +0100, Jiri Olsa wrote:
> Here's new version of event parsing patchset. To summarize:
>  - adding event parser bison/flex generator
>  - the event syntax stays as it was
>  - adding event format file sysfs attribute
>    for pmu device

Added Greg to CC, please also see: https://lkml.org/lkml/2012/1/16/148

Right, lets hope we can convince the sysfs people that a few lines are
ok.. if not we need to find another way to represent all this muck, one
alternative is exploding the whole thing into a sysfs hierarchy like:


format/event: config:0-7
...

format/config: config:0-63
format/config1: config1:0-63
format/config2: config2:0-63

that will of course consume loads more resources but if that's what it
takes :-(

>  - adding new syntax to specify raw events based
>    on the sysfs pmu's format attribute
>    eg. "cpu/config=1,config1=2,config2=3/u" 

fair enough, so we have the attributes from the $FORMAT thingy and (for
now) one hardcoded 'period' thing.

Should we worry about namespace collisions for the built-in vs format
provided names?

I suppose that once we get all this in (and it looks good from my pov),
we can start thinking about doing things like:

events/cycles: event=0x3c

Which together with:

format/event: config:0-7

would allow us to write something like:

cpu/event=cycles/u


