Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422643Ab2EKR56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:57:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38322 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab2EKR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:57:53 -0400
Date: Fri, 11 May 2012 21:56:40 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, khlebnikov@openvz.org,
        xemul@parallels.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: c/r: broken locking when executing map_files
Message-ID: <20120511175640.GA11238@albatros>
References: <1335979380.10666.6.camel@lappy>
 <20120502172756.GD2301@moon>
 <20120503173125.GF19347@moon>
 <20120505182051.GA16029@albatros>
 <20120505185306.GB28746@moon>
 <20120505193201.GA2500@moon>
 <20120506202132.GA6570@albatros>
 <20120506204904.GA1912@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506204904.GA1912@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 00:49 +0400, Cyrill Gorcunov wrote:
> On Mon, May 07, 2012 at 12:21:32AM +0400, Vasiliy Kulikov wrote:
> > On Sat, May 05, 2012 at 23:32 +0400, Cyrill Gorcunov wrote:
> > > On Sat, May 05, 2012 at 10:53:06PM +0400, Cyrill Gorcunov wrote:
> > >  | [root@neptune ~]# /proc/self/map_files/400000-419000
> > > 
> > > it sleeps forever until killed, which is not good I think. Vasiliy, could
> > > you remind me what exactly is problem if we use unlocked ptrace_may_access
> > > here?
> > 
> > There is a race between ptrace_may_access() and dname_to_vma_addr().
> > The target task may do exec() between these calls and
> > dname_to_vma_addr() will be called against a privileged task.  This may
> > lead to a leak of task maps.
> 
> Wait, the proc_map_files_lookup requires the caller to be cap-sysadmin
> granted, would not this be enough?

Yes :-) You can also remove additional checks after capable() in
readdir and revalidate functions.

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
