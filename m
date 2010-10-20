Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0JTNhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:37:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57593 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0JTNhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:37:04 -0400
Date: Wed, 20 Oct 2010 14:36:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John Stoffel <john@stoffel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
Message-ID: <20101020133638.GA19804@ZenIV.linux.org.uk>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
 <1287506215.2530.187.camel@localhost.localdomain>
 <20101019165530.GT19804@ZenIV.linux.org.uk>
 <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
 <20101019172805.GU19804@ZenIV.linux.org.uk>
 <1287512182.3167.130.camel@localhost.localdomain>
 <19646.59971.76978.642955@quad.stoffel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19646.59971.76978.642955@quad.stoffel.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 09:10:27AM -0400, John Stoffel wrote:

> Does this mean I can't replace /bin/sh on a running system using IMA
> at all, even if just one process has it opened and is running?  So how
> the hell am I supposed to do live upgrades on a system?  

rename(2).  Prohibition against write(2) to binary being executed is
*old*.  Try to do the following:
cp /bin/sh /tmp
/tmp/sh &
cat /bin/ls >/tmp/sh
and you'll get
sh: /tmp/sh: Text file busy

That has nothing to do with IMA...
