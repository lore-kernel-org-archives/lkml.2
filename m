Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2AXGxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 01:53:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57499 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2AXGxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 01:53:43 -0500
Date: Tue, 24 Jan 2012 10:53:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-ID: <20120124065338.GB29735@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.181674896@openvz.org>
 <20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:07:30AM +0900, KAMEZAWA Hiroyuki wrote:
...
> 
> From viewpoint I played with seq_file, yesterday.
> 
> > +static void *children_seq_start(struct seq_file *seq, loff_t *pos)
> > +{
> > +	return get_children_pid(seq->private, NULL, *pos);
> > +}
> > +
> > +static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > +{
> > +	struct pid *pid = NULL;
> > +
> > +	pid = get_children_pid(seq->private, v, *pos + 1);
> > +	if (!pid)
> > +		seq_printf(seq, "\n");
> > +	put_pid(v);
> 
> Because seq_printf() may fail. This seems dangeorus.
> 
> If seq_printf() fails and returns NULL, "\n" will not be
> printed out and user land parser will go wrong.
>

Hmm. But userspace app will get eof, so frankly I don't see
a problem here. Or maybe I miss something?

> I think all seq_printf() should be handled in ->show().
> (And you can use seq_putc() for "\n".)
> 

Sure, i'll change it to seq_putc.

	Cyrill
