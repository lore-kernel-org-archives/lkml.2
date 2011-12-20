Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1LTT1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:27:13 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65427 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1LTT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:27:09 -0500
Date: Tue, 20 Dec 2011 20:27:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 1/2] cgroup: Remove unnecessary task_lock before fetching
 css_set on migration
Message-ID: <20111220192703.GB17668@somewhere>
References: <1324320274-18485-1-git-send-email-msb@chromium.org>
 <1324407673-18975-1-git-send-email-fweisbec@gmail.com>
 <20111220191443.GE10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220191443.GE10752@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 11:14:43AM -0800, Tejun Heo wrote:
> Hello, Frederic.
> 
> On Tue, Dec 20, 2011 at 08:01:12PM +0100, Frederic Weisbecker wrote:
> > When we fetch the css_set of the tasks on cgroup migration, we don't need
> > anymore to synchronize against cgroup_exit() that could swap the old one
> > with init_css_set. Now that we are using threadgroup_lock() during
> > the migrations, we don't need to worry about it anymore.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Containers <containers@lists.linux-foundation.org>
> > Cc: Cgroups <cgroups@vger.kernel.org>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Paul Menage <paul@paulmenage.org>
> > Cc: Mandeep Singh Baines <msb@chromium.org>
> 
> I like this but it doesn't apply on top of cgroup/for-3.3.  It
> collides with Mandeep's patch.  Can you please rebase?

Yeah it was made on top of last Mandeep's patch. Let me
rebase on top of your branch, will resend soon.

Thanks.

> 
> Li, can you please ack?
> 
> Thanks.
> 
> -- 
> tejun
