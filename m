Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab1HQRap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:30:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab1HQRao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:30:44 -0400
Date: Wed, 17 Aug 2011 19:27:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linas Vepstas <linasvepstas@gmail.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/eeh: remove eeh_event_handler()->daemonize()
Message-ID: <20110817172713.GA24544@redhat.com>
References: <20110816190858.GA4890@redhat.com> <20110816192629.GB2803@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816192629.GB2803@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Tejun Heo wrote:
>
> On Tue, Aug 16, 2011 at 09:08:58PM +0200, Oleg Nesterov wrote:
> > daemonize() is only needed when a user-space task does kernel_thread().
> >
> > eeh_event_handler() thread is created by the worker kthread, and thus
> > it doesn't need the soon-to-be-deprecated daemonize().
> >
> > Note: looks like eeh_event_wq can be static and it can do all work
> > itself without kernel_thread().
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

> How do you wanna route these?  Through -mm?

Oh, I don't know. -mm, or probably maintainers can pick them.
They don't depend on each other.



Btw. Perhaps we should kill CLONE_KERNEL? And note that the only
user is eeh_thread_launcher().

The problem is, CLONE_KERNEL looks as "use me if you want to create
a kernel thread". But CLONE_SIGHAND means the kernel thread should
not play with signals, and this is not obvious.

Oleg.

