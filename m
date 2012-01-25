Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab2AYGwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:52:25 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48172 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2AYGwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:52:23 -0500
Date: Wed, 25 Jan 2012 10:52:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-ID: <20120125065217.GB2005@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.181674896@openvz.org>
 <20120124155303.acbb3b11.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124155303.acbb3b11.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 03:53:03PM -0800, Andrew Morton wrote:
> On Mon, 23 Jan 2012 18:20:37 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > When we do checkpoint of a task we need to know the list of children
> > the task, has but there is no easy and fast way to generate reverse
> > parent->children chain from arbitrary <pid> (while a parent pid is
> > provided in "PPid" field of /proc/<pid>/status).
> > 
> > So instead of walking over all pids in the system (creating one big process
> > tree in memory, just to figure out which children a task has) -- we add
> > explicit /proc/<pid>/task/<tid>/children entry, because the kernel already has
> > this kind of information but it is not yet exported.
> > 
> > This is a first level children, not the whole process tree.
> 
> Is there a reason for not putting this new code inside
> CONFIG_CHECKPOINT_RESTART?  If so, please changelog that.
> 

I don't know if someone might need it as well, so I've asked in one of
previous iterations if this file is to be under CONFIG_CHECKPOINT_RESTART.
So, sure, I'll wrap it this way.

> We could add
> 
> /* #ifdef CONFIG_CHECKPOINT_RESTART (reasoning goes here) */
> 
> so that if we should decide to pull all this code out again, a grep
> will flag this code for consideration.
> 

	Cyrill
