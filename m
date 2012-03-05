Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2CEQik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:38:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab2CEQij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:38:39 -0500
Date: Mon, 5 Mar 2012 17:31:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120305163130.GA13744@redhat.com>
References: <20120301194120.GA11400@redhat.com> <20120302142630.GK8681@moon> <20120302152621.GA29744@redhat.com> <20120302161247.GO8681@moon> <20120303223333.GB26846@moon> <20120305142130.GA9393@redhat.com> <20120305142655.GC9393@redhat.com> <20120305144648.GA12341@moon> <20120305154029.GB12427@redhat.com> <20120305160127.GM7366@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305160127.GM7366@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Cyrill Gorcunov wrote:
>
> On Mon, Mar 05, 2012 at 04:40:29PM +0100, Oleg Nesterov wrote:
>
> > > This prctl does cheat the kernel
> >
> > Yep. Except, well, it cheats the user-space.
>
> And kernel as well, since this link is not anymore
> the same as it was, and memory read from this file
> (at execution time) will keep data irrelevant to what
> the new symlink points to (but it's exactly by design).

The kernel will never use this file for reading. It is only
used as a placeholder for ->f_path shown in proc.

User-space can be confused, yes, this is by design.

Oleg.

