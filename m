Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab2AYKtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 05:49:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:56298 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2AYKtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 05:49:49 -0500
Subject: Re: [RFCv3 0/9] perf tool: parser generator for events parsing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg KH <greg@kroah.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120125005342.GA24662@kroah.com>
References: <20120109152855.GA1597@m.brq.redhat.com>
	 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1327422364.2446.75.camel@twins>  <20120125005342.GA24662@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 11:49:33 +0100
Message-ID: <1327488573.2614.59.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 16:53 -0800, Greg KH wrote:

> Well, what's to keep someone from exploding one of those files to go
> over the buffer size without knowing it?

The content is known at compile time, we could put checks in. But yeah
4k isn't that much text..

> Even after reading the above link, I can't really understand what this
> is being used for.  As it's sysfs files, why aren't Documentation/ABI/
> files also being created with the patch explaining it all?

Ah, yeah, documentation, wasn't that written in C :-)

But fair enough... Anyway, the purpose is to describe the magic bits
that go into perf_event_attr::config[012] for a particular pmu.

Basically they're the 'hardware' bitmasks we want to export, so that
userspace can deal with sane name/value pairs.

> Again, if at all possible, sysfs should be one value per file.  Please
> NEVER create a sysfs file that requires a parser to determine what is
> going on in it.  It should be a simple 'read the value' type thing.

The whole purpose was to drive a parser :-) Anyway, is:
"config:0-7,32-35" acceptable for a single file?

This means, the 'config' member of struct perf_event_attr bits 0-7,32-35
form a bitfield whose name is then given by the filename that has this
content.

> So yes, multiple sysfs files do make sense, the resource load should be
> almost non-existant for new ones.

Surely all these attribute objects take more space than a few lines of
text, but ok, I guess multiple files it is.

