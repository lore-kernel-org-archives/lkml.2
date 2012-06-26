Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2FZRyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:54:40 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:53876 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2FZRyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:54:39 -0400
Date: Tue, 26 Jun 2012 17:55:14 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Doug Ledford <dledford@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, serge@hallyn.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC, PATCH] CLONE_NEWIPC and exit_group()
Message-ID: <20120626175514.GA32248@mail.hallyn.com>
References: <20120626120425.GA10275@otc-wbsnb-06>
 <20120626170457.GA31175@mail.hallyn.com>
 <20120626174542.GA15482@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626174542.GA15482@otc-wbsnb-06>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kirill A. Shutemov (kirill.shutemov@linux.intel.com):
> On Tue, Jun 26, 2012 at 05:04:57PM +0000, Serge E. Hallyn wrote:
> > Quoting Kirill A. Shutemov (kirill.shutemov@linux.intel.com):
> > > Hi,
> > > 
> > > Patch to move kern_unmount() out of exit_group() code path is below.
> > > Dmitry, could you check if it's beneficial for your use-case?
> > 
> > Hi,
> > 
> > sorry, I don't seem to have the thread handy for contest.  What is the
> > point of this?  The work being moved was not being done under lock,
> > so what is this meant to gain?
> 
> It's basically addition to this patch (tested with the patch applied):
> 
> http://thread.gmane.org/gmane.linux.kernel.cifs/6347/focus=23929
> 
> Some context: Dmitry has workload which run a lot of short-living tasks in
> sandboxed environment. He noticed that exit_group() syscall of the last
> process in IPC namespace is a bottleneck.
> 
> The bottleneck was mainly due rcu_barrier() in kern_umount(). It's fixed
> by patch in the link (Andrew took it in -mm).
> 

Ah I see, thanks.

> But probably having kern_umount() in exit_group() code path is not a good
> idea from scalability point of view?..

OTOH, does doing that mean that the extra processing time is (correctly)
accounted to the exiting user?  Just a thought.  But your argument also
makes sense, and I see no problem with the patch, so

Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

thanks,
-serge
