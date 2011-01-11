Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab1AKMrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:47:18 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:57320 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1AKMrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u4FsKe+Fzf3PMuVNt6NabOFInCbXj8obmR5NsXuw35NkiMGG+hQlOEj44YBLIhej0U
         YsXUbH4IvN8yGAyacUq888luCH4As503XJrFojrJbUEK//R4SLSxra5TRaI6kiuJhB/w
         hsUXOSebS7A5EIstP58e0fUmPlauRNXq+Vqgc=
Date: Tue, 11 Jan 2011 20:46:58 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/2] [PATCH -tip 1/2] sched: Reinstate group names
 in /proc/sched_debug.
Message-ID: <20110111124658.GA4507@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110111101040.GD4772@in.ibm.com>
 <20110111101153.GE4772@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110111101153.GE4772@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 03:41:54PM +0530, Bharata B Rao wrote:
> sched: Reinstate group names in /proc/sched_debug.
> 
> Displaying of group names in /proc/sched_debug was dropped in autogroup
> patches. Add group names while displaying cfs_rq and tasks information.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  kernel/sched_debug.c |   35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -16,6 +16,8 @@
>  #include <linux/kallsyms.h>
>  #include <linux/utsname.h>
>  
> +static DEFINE_SPINLOCK(sched_debug_lock);

I don't get your point on introducing this lock.
Just to avoid concurrent access?
Or could you explain please?

Thanks,
Yong
