Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910Ab2KAN3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:29:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab2KAN2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:28:50 -0400
Date: Thu, 1 Nov 2012 09:28:38 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, James Morris <jmorris@namei.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH] device_cgroup: fix unchecked cgroup parent usage
Message-ID: <20121101132837.GE14789@redhat.com>
References: <20121031160430.GD14789@redhat.com>
 <20121031163501.79a0950e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031163501.79a0950e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 04:35:01PM -0700, Andrew Morton wrote:
> On Wed, 31 Oct 2012 12:04:30 -0400
> Aristeu Rozanski <aris@redhat.com> wrote:
> 
> > In 4cef7299b4786879a3e113e84084a72b24590c5b the cgroup parent usage is
> > unchecked. root will not have a parent and trying to use
> > device.{allow,deny} will cause problems.
> 
> From my reading of the code "problems" means "kernel null pointer
> dereference".

yes. you want me to resubmit it fixing it or you want to update it?

> >  static inline int may_allow_all(struct dev_cgroup *parent)
> 
> offtopic: this function could quite neatly have a bool return type.

ok, will do.

> >  {
> > +	if (!parent)
> > +		return 1;
> 
> hm.  Does it need a comment explaining what and why?  I guess not...  just.

it's because the root's parent has to always allows full access to all
devices. I can add a comment when I turn into a bool if you want.

-- 
Aristeu

