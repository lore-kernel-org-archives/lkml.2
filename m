Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2G3PiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:38:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41221 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2G3PiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:38:09 -0400
Date: Mon, 30 Jul 2012 08:38:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miao Xie <miaox@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [ 39/40] cpuset: mm: reduce large amounts of memory barrier
 related damage v3
Message-ID: <20120730153806.GA29697@kroah.com>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
 <20120726211414.752069185@linuxfoundation.org>
 <20120727150823.GD3033@herton-Z68MA-D2H-B3>
 <20120727152347.GG612@suse.de>
 <20120727190116.GA29646@kroah.com>
 <20120728050230.GA9155@herton-Z68MA-D2H-B3>
 <20120730153731.GA28633@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730153731.GA28633@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 08:37:31AM -0700, Greg Kroah-Hartman wrote:
> On Sat, Jul 28, 2012 at 02:02:31AM -0300, Herton Ronaldo Krzesinski wrote:
> > Thanks. I saw what seems another issue now on the patch too, sorry for
> > not noticing earlier: this backport is lacking the
> > write_seqcount_{begin,end} on set_mems_allowed for the case with
> > CONFIG_CPUSETS, like in the original patch:
> > 
> >  static inline void set_mems_allowed(nodemask_t nodemask)
> >  {
> >         task_lock(current);
> > +       write_seqcount_begin(&current->mems_allowed_seq);
> >         current->mems_allowed = nodemask;
> > +       write_seqcount_end(&current->mems_allowed_seq);
> >         task_unlock(current);
> >  }
> > 
> 
> Ok, but that's not in a patch format that I can apply :(
> 
> Care to redo it so I can add it to the existing patch?

Oh nevermind, Mel already did it.

Time for more coffee...

greg k-h
