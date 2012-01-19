Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab2ASRIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:08:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38030 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab2ASRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:08:08 -0500
Date: Thu, 19 Jan 2012 21:07:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry
 v6
Message-ID: <20120119170751.GH31379@moon>
References: <4F15EA53.8030405@gmail.com>
 <20120118135809.GA10105@redhat.com>
 <20120118142156.GR1968@moon>
 <20120118143631.GA11776@redhat.com>
 <20120118182344.GD2889@moon>
 <20120118190725.GE2889@moon>
 <20120119141051.GA9652@redhat.com>
 <20120119155529.GA14412@redhat.com>
 <20120119162718.GA32568@moon>
 <20120119164413.GA16522@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119164413.GA16522@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 05:44:13PM +0100, Oleg Nesterov wrote:
> On 01/19, Cyrill Gorcunov wrote:
> >
> > On Thu, Jan 19, 2012 at 04:55:29PM +0100, Oleg Nesterov wrote:
> > >
> > > Thinking more... I am not sure, but do we really need
> > > proc_pid_children_iter at all??
> > >
> > > It is very possibly I missed something, but we can get both
> > > parent_pid and pid_ns from inode, right? so can't we just remember
> > > inode in seq->private?
> >
> > Good point. Letme check if we will need to call for ihold then...
> > (/me scratchig the head)
> 
> Why? file/inode can't go away, at least until this fd is closed.
> 
> And just in case, get_pid(proc_pid(inode)) is not needed, even in v6/v7.
> I didn't realize this.
> 

Grr, indeed.

> Cyrill, I won't argue if you prefer to make this in a separate patch
> (of course, assuming you are agree) on top of v7, to me it looks
> "good enough".
> 

I think better to make completely updated version then, than pushing
changes on top. it'll be better to put anything in one patch I think.

Thanks!

	Cyrill
