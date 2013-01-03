Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab3ACQ31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:29:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39380 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3ACQ3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:29:24 -0500
Date: Thu, 3 Jan 2013 16:23:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Keun-O Park <kpark3469@gmail.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>
Subject: Re: [PATCH 2/2] arm: make return_address available for ARM_UNWIND
Message-ID: <20130103162359.GR2631@n2100.arm.linux.org.uk>
References: <1357207949-3349-1-git-send-email-kpark3469@gmail.com> <1357207949-3349-2-git-send-email-kpark3469@gmail.com> <20130103103815.GL2631@n2100.arm.linux.org.uk> <CA+KhAHbmjD7zTw+wcw84Abg3V1dD=0Ea4kUpYdGENQf1UOWphw@mail.gmail.com> <1357220165.10284.30.camel@gandalf.local.home> <20130103141301.GQ2631@n2100.arm.linux.org.uk> <1357229038.10284.46.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357229038.10284.46.camel@gandalf.local.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 11:03:58AM -0500, Steven Rostedt wrote:
> On Thu, 2013-01-03 at 14:13 +0000, Russell King - ARM Linux wrote:
> > In summary, from what I can see in the patch, the reason why the ifdefs
> > are the way they are, and the reason the warning is there has not been
> > addressed; these patches just seem to be aimed just at removing a #warning
> > statement to make the warning go away.
> 
> You're correct that this patch does not solve any of theses issues. Now,
> I'm thinking that ftrace has matured where these issues don't exist, and
> where they do, it will only cause noise in the trace than anything
> serious. But, this needs to be looked deeper to make sure.

Looking back in the archives, it seems that we had a problem with ftrace
and the unwinder polluting the trace information:

http://lists.arm.linux.org.uk/lurker/message/20090604.201745.1c41ee6c.en.html

There's quite a bit of discussion in that thread about this which details
why we came up with what we have today.
