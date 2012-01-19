Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab2ASQun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:50:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab2ASQum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:50:42 -0500
Date: Thu, 19 Jan 2012 17:44:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children
	entry v6
Message-ID: <20120119164413.GA16522@redhat.com>
References: <20120116153231.GF2998@moon> <4F15EA53.8030405@gmail.com> <20120118135809.GA10105@redhat.com> <20120118142156.GR1968@moon> <20120118143631.GA11776@redhat.com> <20120118182344.GD2889@moon> <20120118190725.GE2889@moon> <20120119141051.GA9652@redhat.com> <20120119155529.GA14412@redhat.com> <20120119162718.GA32568@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119162718.GA32568@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Cyrill Gorcunov wrote:
>
> On Thu, Jan 19, 2012 at 04:55:29PM +0100, Oleg Nesterov wrote:
> >
> > Thinking more... I am not sure, but do we really need
> > proc_pid_children_iter at all??
> >
> > It is very possibly I missed something, but we can get both
> > parent_pid and pid_ns from inode, right? so can't we just remember
> > inode in seq->private?
>
> Good point. Letme check if we will need to call for ihold then...
> (/me scratchig the head)

Why? file/inode can't go away, at least until this fd is closed.

And just in case, get_pid(proc_pid(inode)) is not needed, even in v6/v7.
I didn't realize this.

Cyrill, I won't argue if you prefer to make this in a separate patch
(of course, assuming you are agree) on top of v7, to me it looks
"good enough".

Oleg.

