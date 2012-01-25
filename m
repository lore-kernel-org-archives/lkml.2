Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab2AYA4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:56:20 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56304 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138Ab2AYA4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:56:19 -0500
X-Sasl-enc: V9psROEqOcR5L2msAOXjw4ZSlWwIfFQPPOXw/LKRU3RS 1327452978
Date: Tue, 24 Jan 2012 16:53:42 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv3 0/9] perf tool: parser generator for events parsing
Message-ID: <20120125005342.GA24662@kroah.com>
References: <20120109152855.GA1597@m.brq.redhat.com>
 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327422364.2446.75.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327422364.2446.75.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 05:26:04PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-01-16 at 13:31 +0100, Jiri Olsa wrote:
> > Here's new version of event parsing patchset. To summarize:
> >  - adding event parser bison/flex generator
> >  - the event syntax stays as it was
> >  - adding event format file sysfs attribute
> >    for pmu device
> 
> Added Greg to CC, please also see: https://lkml.org/lkml/2012/1/16/148
> 
> Right, lets hope we can convince the sysfs people that a few lines are
> ok.. if not we need to find another way to represent all this muck, one
> alternative is exploding the whole thing into a sysfs hierarchy like:
> 
> 
> format/event: config:0-7
> ...
> 
> format/config: config:0-63
> format/config1: config1:0-63
> format/config2: config2:0-63
> 
> that will of course consume loads more resources but if that's what it
> takes :-(

Well, what's to keep someone from exploding one of those files to go
over the buffer size without knowing it?

Even after reading the above link, I can't really understand what this
is being used for.  As it's sysfs files, why aren't Documentation/ABI/
files also being created with the patch explaining it all?

Again, if at all possible, sysfs should be one value per file.  Please
NEVER create a sysfs file that requires a parser to determine what is
going on in it.  It should be a simple 'read the value' type thing.

So yes, multiple sysfs files do make sense, the resource load should be
almost non-existant for new ones.

thanks,

greg k-h
