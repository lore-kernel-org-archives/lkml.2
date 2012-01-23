Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2AWTdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:33:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35001 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2AWTdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:33:07 -0500
Date: Mon, 23 Jan 2012 23:33:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-ID: <20120123193301.GI1907@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.181674896@openvz.org>
 <CAGXu5j+JrntZcr1sZ1sHXmOTT5jCuMp5HUQnucHqEgF+LXX5VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5j+JrntZcr1sZ1sHXmOTT5jCuMp5HUQnucHqEgF+LXX5VA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 10:54:53AM -0800, Kees Cook wrote:
> On Mon, Jan 23, 2012 at 6:20 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > When we do checkpoint of a task we need to know the list of children
> > the task, has but there is no easy and fast way to generate reverse
> > parent->children chain from arbitrary <pid> (while a parent pid is
> > provided in "PPid" field of /proc/<pid>/status).
> > [...]
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Pavel Emelyanov <xemul@parallels.com>
> > Cc: Serge Hallyn <serge.hallyn@canonical.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> > +static int children_seq_show(struct seq_file *seq, void *v)
> > +{
> > +       struct inode *inode = seq->private;
> > +       pid_t pid;
> > +
> > +       pid = pid_nr_ns(v, inode->i_sb->s_fs_info);
> > +       return seq_printf(seq, " %d", pid);
> > +}
> 
> Does this mean the file contents always starts with a space? I think
> I'd prefer a trailing space than a leading one. Better yet, neither.
> :)
> 

Yeah, it there children, they will be in say " 1 2 3 4\n" format.
To drop this space completely i'll have to add more code, which I
actually trying to escape. Can we live with it? ;)

	Cyrill
