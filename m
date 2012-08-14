Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2HNR52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:57:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57746 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab2HNRyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:54:40 -0400
Date: Tue, 14 Aug 2012 10:54:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>,
        Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: workqueues and percpu (was: [PATCH] dm: remake of the verity
 target)
Message-ID: <20120814175431.GR25632@google.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
 <20120306215947.GB27051@google.com>
 <Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
 <20120308143909.bfc4cb4d.akpm@linux-foundation.org>
 <20120308231521.GA2968@htj.dyndns.org>
 <20120309211512.GL27051@google.com>
 <20120309212049.GD24890@google.com>
 <20120309220623.GM27051@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309220623.GM27051@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 09, 2012 at 02:06:23PM -0800, Mandeep Singh Baines wrote:
> > I think the right thing to do for now is to add cpu hotplug notifier
> > and do flush_work_sync() on the work item.  We can later move that
> > logic into workqueue and remove it from crypto.
> > 
> 
> That seems like the correct solution. I will implement that.

So, I've been looking at it and now am not so sure whether moving it
to workqueue core is necessary.  With the proposed workqueue updates,
workqueue's behavior is now closely aligned with the timer which also
considers the specified affinity overridable (to avoid reentrancy and
during CPU offlining) and I don't think it's reasonable to require
users which need strict affinity to implement proper CPU up/down
notifiers - in many cases, they need them anyway.  I'll try to review
the current users and think more about it.

Thanks.

-- 
tejun
