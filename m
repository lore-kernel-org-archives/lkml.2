Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2AYGy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:54:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53925 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab2AYGyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:54:55 -0500
Date: Wed, 25 Jan 2012 10:54:50 +0400
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
Message-ID: <20120125065450.GC2005@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.336126707@openvz.org>
 <20120124155941.4f7453d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124155941.4f7453d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 03:59:41PM -0800, Andrew Morton wrote:
> On Mon, 23 Jan 2012 18:20:39 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > We would like to have an ability to restore command line
> > arguments and envirion pointers so the task being restored
> > would print appropriate values in /proc/pid/cmdline and
> > /proc/pid/envirion. The exit_code is needed to restore
> > zombie tasks.
> > 
> 
> Please update Documentation/filesystems/proc.txt.

ok

> > +		(mm && permitted) ? mm->start_brk : 0,
> > +		(mm && permitted) ? mm->arg_start : 0,
> > +		(mm && permitted) ? mm->arg_end : 0,
> > +		(mm && permitted) ? mm->env_start : 0,
> > +		(mm && permitted) ? mm->env_end : 0,
> > +		task->exit_code);
> >  	if (mm)
> >  		mmput(mm);
> >  	return 0;
> 
> /proc/pid/stat is getting out of control.  People are now sending patches
> because reading from this thing already takes too long.
> 
> The problem is that if you only want one field, you have to incur the
> cost of preparing all the fields.  The magnitude of this problem
> increases exponentially over time!
> 
> I'm unsure what to do about it really.  Perhaps add a new
> /proc/pid/mmstat for MM-specific things.  We could put the above six
> fields in there, as long as we move quickly.
> 

I can add prctl PR_GET_MM with subcodes, since PR_SET_MM is already here
and wrapped with CHECKPOINT_RESTORE. Would this be better?

	Cyrill
