Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2AYHSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 02:18:20 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35132 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2AYHST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 02:18:19 -0500
Date: Wed, 25 Jan 2012 11:18:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [patch 3/4] c/r: procfs: add arg_start/end, env_start/end and
 exit_code members to /proc/$pid/stat
Message-ID: <20120125071814.GE2005@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.336126707@openvz.org>
 <20120124155941.4f7453d4.akpm@linux-foundation.org>
 <20120125065450.GC2005@moon>
 <20120124231245.e4c68f90.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124231245.e4c68f90.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:12:45PM -0800, Andrew Morton wrote:
> On Wed, 25 Jan 2012 10:54:50 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > > /proc/pid/stat is getting out of control.  People are now sending patches
> > > because reading from this thing already takes too long.
> 
> err, actually, that was /proc/stat/
> 

Ah! (I saw those thread, but then I get confused and thought maybe there were
for /proc/pid/stat as well but I simply missed it ;)

> > 
> > I can add prctl PR_GET_MM with subcodes, since PR_SET_MM is already here
> > and wrapped with CHECKPOINT_RESTORE. Would this be better?
> 
> mm, not really - /proc is the logical/expected place for it.
> 
> I'm thinking that perhaps we should start again with all of this and
> export all this information in brand new, well-designed procfs files. 
> We'd still maintain /proc/stat and /proc/pid/stat but people should
> migrate off them.  Eventually (10 years?) everyone will be setting their
> CONFIG_PROC_[PID_]STAT to 'n' and perhaps we can retire the things.
> 
> Meanwhile, I suppose you may as well continue to make /proc/pid/stat
> even crazier :(  It isn't as bad as /proc/stat!
> 

At moment indeed it's not that bloated... yet.

> btw, do we really need to do "(mm && permitted)" so many times?  ie,
> can we split that seq_printf up and do
> 
> 	if (mm && permitted) {
> 		seq_printf(m + offset, "%lu", mm->start_data);
> 		...
> 	} else {
> 		seq_printf(m + offset, "0 0 0 0 0 0 0 0 0");
> 	}
> 
> ?  Although this probably won't help much.
> 

Yeah we can. I'll update.

	Cyrill
