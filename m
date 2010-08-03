Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab0HCRER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:04:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39009 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab0HCREP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:04:15 -0400
Date: Tue, 3 Aug 2010 10:04:04 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <20100803170404.GH3948@outflux.net>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
 <20100802122421.GA12130@infradead.org>
 <20100802165936.GV3948@outflux.net>
 <1280774061.2673.115.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280774061.2673.115.camel@moss-terrapins.epoch.ncsc.mil>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Aug 02, 2010 at 02:34:21PM -0400, David P. Quigley wrote:
> On Mon, 2010-08-02 at 09:59 -0700, Kees Cook wrote:
> [...snip]
> > 
> > I've seen two so far. Both are addressed with a one line fix. And I would
> > stress that no other existing subsystem in the kernel can provide the same
> > level of control that my ptrace exception logic provides. SELinux cannot do
> > this.
> > 
> 
> Would you mind explaining to me what you believe this patch can do that
> SELinux can't? Based on what I read in the kconfig entry for the feature
> and the subsequent exception patch I'm not seeing anything here that
> SELinux can't do. If there is something we are missing I'd like to
> understand it so we can make the decision on whether or not our ptrace
> access control checks need to be modified.

Sure thing. When looking at how PTRACE is used, it seemed clear that there
were exactly 2 use-cases:
 - tracking children (either for monitoring or debugging)
 - in-memory crash handlers

Allowing child-tracing was easy: this is discoverable through process
ancestry. Doing the crash handlers is different, since the handler can come
from anywhere. One thing that seemed common was that the crashing program
would know which pid was going to attach to it, so if those programs
declared to the kernel which pid is allowed to attach, then it could make
an exception for it. I did not find a heuristic approach that the kernel
could use to figure this out for itself (maybe I missed something).

It seems to me that SELinux (and AppArmor and maybe others?) can
declare general relationships of who can PTRACE who, etc, but nothing
that specifically says "only _this_ instance". Instead of "the crash
handler binary running as $identity can attach to program foo running
as $identity", it is "the crash handler process specified by program foo
at the time of the crash, can attach to foo", which is much more specific.

If there's a way to do this already, I am genuinely interested to learn
more about it. Perhaps I've grossly misunderstood something.

-Kees

-- 
Kees Cook
Ubuntu Security Team
