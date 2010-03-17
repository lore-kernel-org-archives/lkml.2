Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0CQK0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:26:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0CQK0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:26:19 -0400
Subject: Re: [PATCH -tip 10/10] perf probe: Accessing members in data
 structures
From: Mark Wielaard <mjw@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20100316220626.32050.57552.stgit@localhost6.localdomain6>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
	 <20100316220626.32050.57552.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 11:25:37 +0100
Message-ID: <1268821537.6022.12.camel@springer.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 18:06 -0400, Masami Hiramatsu wrote:
> Support accessing members in the data structures. With this,
> perf-probe accepts data-structure members(IOW, it now accepts
> dot '.' and arrow '->' operators) as probe arguemnts.
> 
> e.g.
> 
>  ./perf probe --add 'schedule:44 rq->curr'
> 
>  ./perf probe --add 'vfs_read file->f_op->read file->f_path.dentry'
> 
> Note that '>' can be interpreted as redirection in command-line.

If you find that a problem then you can do like SystemTap does and allow
'.' in place of '->'. In the code you already use the
perf_probe_arg_field ref flag only to check that the DIE gives you the
same information. So you could just drop that and use any separator.
Then you decide based on whether you see a DW_TAG_pointer_type. This
gives the user some extra flexibility by letting them not having to care
about specifying extra type information already available elsewhere.

Cheers,

Mark

