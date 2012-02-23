Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab2BWRdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:33:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52187 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2BWRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:33:53 -0500
Date: Thu, 23 Feb 2012 09:33:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120223173348.GD22536@google.com>
References: <20120221211938.GE12236@google.com>
 <4F45F742.1060605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F45F742.1060605@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Thu, Feb 23, 2012 at 04:22:26PM +0800, Li Zefan wrote:
> > The following is a "best practices" document on using cgroups.
> > 
> >   http://www.freedesktop.org/wiki/Software/systemd/PaxControlGroups
> > 
> > To me, it seems to demonstrate the rather ugly situation that the
> > current cgroup is providing.  Everyone should tip-toe around cgroup
> > hierarchies and nobody has full knowledge or control over them.
> > e.g. base system management (e.g. systemd) can't use freezer or task
> > counter as someone else might want to use it for different hierarchy
> > layout.
> > 
> 
> This issue still exists if we allow a single hierarchy only, right?
> Different cgroup users/applications have to struggle not to step
> on each other's toe.

Oh sure, having single hierarchy doesn't solve that problem but makes
it clear that there's single representation that kernel understands
and deals with.  I think the problem now is that kernel tries to
multiplex multiple users.  Unfortunately, it does that half-way and
badly and I think the nature of the problem doesn't really allow
proper muxed interface at kernel layer.  So, I'm suggesting to let go
of the broken pretense and just have a single unified interfce and let
userland deal with resource allocation policies.

Thanks.

-- 
tejun
