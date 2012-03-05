Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab2CEOqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:46:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43983 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab2CEOqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:46:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.154.2 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Mon, 5 Mar 2012 18:46:48 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120305144648.GA12341@moon>
References: <20120229200103.GJ11326@moon>
 <20120301180616.GA7652@redhat.com>
 <20120301191714.GF9930@moon>
 <20120301194120.GA11400@redhat.com>
 <20120302142630.GK8681@moon>
 <20120302152621.GA29744@redhat.com>
 <20120302161247.GO8681@moon>
 <20120303223333.GB26846@moon>
 <20120305142130.GA9393@redhat.com>
 <20120305142655.GC9393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305142655.GC9393@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 03:26:55PM +0100, Oleg Nesterov wrote:
> > OK, I won't argue, probably this makes sense to make sure that
> > admin can't get a heart attack looking at /proc/pid/exe.
> >
> > But the O_RDONLY check looks strange. We are not going to write
> > to this file, we only set the name (and that is why I think it
> > should be mm->exe_path). What is the point to check that the file
> > was opened without FMODE_WRITE? Even if there were any security
> > risk the apllication can open this file again with the different
> > flags.
>

Hi Oleg!

Replying to both your email -- I wanted to be as close to open_exec
as possible. This prctl does cheat the kernel but with this tests
the cheating should be minimized (it's almost the same as open_exec
does).

> Seriously, I think we should cleanup this before c/r adds more
> ugliness. I'll try to make the patch today.
> 

Cleanup what? If you mean this patch -- just point me what
should I do.

> And with all these checks I am no longer sure that fd is better
> than filename ;)

This security tests was a reason why I've used open_exec in
first version of the patch (and I still would prefer to
have open_exec here instead of fd).

As to allow-write-access -- it should be cleaned once process
finished, no?

	Cyrill
