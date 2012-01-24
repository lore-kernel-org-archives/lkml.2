Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2AXHIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 02:08:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39481 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2AXHIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 02:08:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Jan 2012 16:07:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-Id: <20120124160709.e05c51b5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120124065338.GB29735@moon>
References: <20120123142036.025893883@openvz.org>
	<20120123142436.181674896@openvz.org>
	<20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124065338.GB29735@moon>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 10:53:38 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Tue, Jan 24, 2012 at 11:07:30AM +0900, KAMEZAWA Hiroyuki wrote:
> ...
> > 
> > From viewpoint I played with seq_file, yesterday.
> > 
> > > +static void *children_seq_start(struct seq_file *seq, loff_t *pos)
> > > +{
> > > +	return get_children_pid(seq->private, NULL, *pos);
> > > +}
> > > +
> > > +static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > > +{
> > > +	struct pid *pid = NULL;
> > > +
> > > +	pid = get_children_pid(seq->private, v, *pos + 1);
> > > +	if (!pid)
> > > +		seq_printf(seq, "\n");
> > > +	put_pid(v);
> > 
> > Because seq_printf() may fail. This seems dangeorus.
> > 
> > If seq_printf() fails and returns NULL, "\n" will not be
> > printed out and user land parser will go wrong.
> >
> 
> Hmm. But userspace app will get eof, so frankly I don't see
> a problem here. Or maybe I miss something?
> 

Userspace need to take care of whether there may be"\n" or not even
if read() returns EOF.
As an interface, it's BUG to say "\n" will be there if you're lucky!"
(*) I know script language can handle this but we shouldn't assume that.

How about just remove "\n" at EOF  ? I think it's unnecessary.

Thanks,
-Kame


