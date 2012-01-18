Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab2ARSXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:23:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60026 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2ARSXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:23:50 -0500
Date: Wed, 18 Jan 2012 22:23:44 +0400
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
Message-ID: <20120118182344.GD2889@moon>
References: <20120116153231.GF2998@moon>
 <4F15EA53.8030405@gmail.com>
 <20120118135809.GA10105@redhat.com>
 <20120118142156.GR1968@moon>
 <20120118143631.GA11776@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118143631.GA11776@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 03:36:31PM +0100, Oleg Nesterov wrote:
> On 01/18, Cyrill Gorcunov wrote:
> >
> > So Oleg, I think you meant something like below? Comment is moved down an
> > list_empty over siblings remans, right?
> 
> Yes, except the comment still looks misleading to me.
> 
> Otherwise looks correct, but I'll try to re-check once again with
> the fresh head. Although I think you should remove me from CC: after
> I found the nonexistent bug ;)
> 

There is no way back from CC ;)

> This is minor, but "freshly created" looks very confusing to me.
> What does it mean? We hold tasklist, we can't race with fork().
> 

Hmm. Sure we keep a lock here, but changes might happen between reads
If only I'm not missing something again.

Look which scenario I've had in mind. We have a task A and children B,C,D,E.
... Here my scenario ended and I realised that you're right. I'll update
the comment.

> Yes we can miss a child, but this has nothing to do with "freshly".
> Just suppose that the parent sleeps, but N children exit after we
> printed their tids. Now the slow paths skips N extra children, we
> miss N tasks.
> 
> Oleg.
> 

	Cyrill
