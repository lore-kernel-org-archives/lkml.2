Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0DZKZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 06:25:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab0DZKZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 06:25:43 -0400
Subject: Re: [PATCH] procfs: fix tid fdinfo
From: Miklos Szeredi <mszeredi@suse.cz>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vic Abell <abe@purdue.edu>
In-Reply-To: <4BD54573.3020801@redhat.com>
References: <4BD1BF57.7070201@redhat.com>
	 <20100423111620.100840fe.akpm@linux-foundation.org>
	 <20100424192735.GA5157@x200>
	 <1272053239.4456.4.camel@tucsk.pomaz.szeredi.hu>
	 <4BD54573.3020801@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 12:26:03 +0200
Message-ID: <1272277563.4456.24.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-26 at 09:49 +0200, Jerome Marchand wrote:
> On 04/23/2010 10:07 PM, Miklos Szeredi wrote:
> > On Sat, 2010-04-24 at 22:27 +0300, Alexey Dobriyan wrote:
> >> On Fri, Apr 23, 2010 at 11:16:20AM -0700, Andrew Morton wrote:
> >>> On Fri, 23 Apr 2010 17:40:07 +0200
> >>>> -	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fd_operations),
> >>>> +	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
> >>
> >>> hm, the code's been like that for over a year.  What are the
> >>> user-visible effects of the bug, and of this change?
> >>
> >> /proc/*/task/*/fdinfo contains symlinks to opened files like /proc/*/fd/
> >> which is cool bug :-)
> > 
> > Yeah, at least now we can see that someone has started using this
> > interface ;)
> 
> AFAIK there is still nobody using it, but lsof should use it, and 
> /proc/<pid>/task/<tid>/fd/ too. I haven't checked the code, but as it is
> now, it doesn't spot files open by a thread which does share its father's
> file descriptor table.

Yes, apparently "lsof" doesn't care about contents of /proc/$PID/task.
Well, tasks with separate file descriptor tables are rare, POSIX threads
share their descriptor tables.  But it would be nice if this were fixed.

Thanks,
Miklos


