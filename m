Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab0DXNli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 09:41:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35738 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab0DXNlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 09:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vBwonveWqzogc05b9GOB8niTgv26GCocw8Jb/LqSbEi+oNvE+wCf9Dtdg8LNSC73ow
         0Wx6FS/eISpodaUFqsbAn0+Ee8OikxzDEM06UdBarc3eao5/edjV9f+htTn8gxhRu6g4
         XL9JxH0WIAIKI9oFpzJkuxWXu0TMd0+cyTF3E=
Date: Sat, 24 Apr 2010 15:41:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH v2] perf lock: add "info" subcommand for dumping misc
	information
Message-ID: <20100424134143.GB5545@nowhere>
References: <1272074742-3654-2-git-send-regression-fweisbec@gmail.com> <1272106001-10519-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272106001-10519-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 07:46:41PM +0900, Hitoshi Mitake wrote:
> Hi Frederic,
> 
> I added "info" subcommand to perf lock,
> this can be used as dumping metadata like thread or address of lock instances.
> "map" was removed because info should do the work of it.
> 
> This will be useful not only for debugging but also for ordinary analyzing.
> 
> I made this patch on perf/core of your tree, could you queue this?
> 
> v2: adding example of usage
> % sudo ./perf lock info -t
>  | Thread ID: comm
>  | 	 0: swapper
>  |         1: init
>  |        18: migration/5
>  |        29: events/2
>  |        32: events/5
>  |        33: events/6
> ...
> 
> % sudo ./perf lock info -m
> | Address of instance: name of class
> |  0xffff8800b95adae0: &(&sighand->siglock)->rlock
> |  0xffff8800bbb41ae0: &(&sighand->siglock)->rlock
> |  0xffff8800bf165ae0: &(&sighand->siglock)->rlock
> |  0xffff8800b9576a98: &p->cred_guard_mutex
> |  0xffff8800bb890a08: &(&p->alloc_lock)->rlock
> |  0xffff8800b9522a08: &(&p->alloc_lock)->rlock
> |  0xffff8800bb8aaa08: &(&p->alloc_lock)->rlock
> |  0xffff8800bba72a08: &(&p->alloc_lock)->rlock
> |  0xffff8800bf18ea08: &(&p->alloc_lock)->rlock
> |  0xffff8800b8a0d8a0: &(&ip->i_lock)->mr_lock
> |  0xffff88009bf818a0: &(&ip->i_lock)->mr_lock
> |  0xffff88004c66b8a0: &(&ip->i_lock)->mr_lock
> |  0xffff8800bb6478a0: &(shost->host_lock)->rlock



Thanks, I queue it for the next pass.

