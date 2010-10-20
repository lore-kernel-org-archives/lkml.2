Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab0JTOKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:10:50 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:61168 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0JTOKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:10:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19646.63514.852665.500420@quad.stoffel.home>
Date: Wed, 20 Oct 2010 10:09:30 -0400
From: "John Stoffel" <john@stoffel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: John Stoffel <john@stoffel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
In-Reply-To: <20101020133638.GA19804@ZenIV.linux.org.uk>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
	<AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
	<1287506215.2530.187.camel@localhost.localdomain>
	<20101019165530.GT19804@ZenIV.linux.org.uk>
	<AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
	<20101019172805.GU19804@ZenIV.linux.org.uk>
	<1287512182.3167.130.camel@localhost.localdomain>
	<19646.59971.76978.642955@quad.stoffel.home>
	<20101020133638.GA19804@ZenIV.linux.org.uk>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Al" == Al Viro <viro@ZenIV.linux.org.uk> writes:

Al> On Wed, Oct 20, 2010 at 09:10:27AM -0400, John Stoffel wrote:
>> Does this mean I can't replace /bin/sh on a running system using IMA
>> at all, even if just one process has it opened and is running?  So how
>> the hell am I supposed to do live upgrades on a system?  

Al> rename(2).  Prohibition against write(2) to binary being executed is
Al> *old*.  Try to do the following:
Al> cp /bin/sh /tmp
Al> /tmp/sh &
Al> cat /bin/ls >/tmp/sh
Al> and you'll get
Al> sh: /tmp/sh: Text file busy

Al> That has nothing to do with IMA...

Duh, makes sense.  Thanks for educating me.  I still IMA is a waste of
system resources...

John
