Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab2CSXMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:12:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59569 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758590Ab2CSXMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:12:16 -0400
Date: Tue, 20 Mar 2012 03:12:12 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new
 mm_struct::exe_file
Message-ID: <20120319231212.GD21262@moon>
References: <20120316205556.595309230@openvz.org>
 <20120316210343.925446961@openvz.org>
 <20120319151507.93bab32a.akpm@linux-foundation.org>
 <20120319223941.GJ19594@moon>
 <CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
 <20120319154649.0687f545.akpm@linux-foundation.org>
 <20120319225020.GL19594@moon>
 <20120319155926.8d1d8f0e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319155926.8d1d8f0e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:59:26PM -0700, Andrew Morton wrote:
...
> > 
> > It can use it iif CAP_SYS_RESOURCE is granted.
> > Otherwise you'll get -eaccess.
> 
> A rootkit already obtained CAP_SYS_RESOURCE.  What we're concerned
> about here is its ability to hide itself from view and its ability to
> obscure the way in which it obtained elevated privs.

Well, if rootkit got CAP_SYS_RESOURCE I think we're in bad situation
then -- it might change the symlink to some 'known' and trusted
application and you'll never notice that (without scanning the
memory area such rootkit uses, and note 'scanning' here because
you need to scan for memory contents to figure out that memory
do not correspond the file symlinks point to).

Actually being able to restore program 'transparently' is a primary
aim of checkpoint-restore itself.

> 
> How much this patch worsens the situation is unclear to me, so let's
> think it through.

Dunno Andrew, /proc/exe/symlink is never trusted source of info I guess.
But I need to think some more...

	Cyrill
