Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1EKTqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:46:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61777 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab1EKTqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xSz5XPYSKS3KggmoqFY4nbNT5NScjP7lhCZVTLpMkitd5yDEFqQnaApOZc8IKmgxVi
         6cq4xaHd2S39XlO5Svbhz9xxdfd9xK61qC8OouuPmyupGBNQEj/oUlqRFDq/JAcQVCSL
         78N5znJhJ2uRkN6TbtHljC3GDR2fkf5CWo774=
Date: Wed, 11 May 2011 21:45:51 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and
 ptrace_check_attach()
Message-ID: <20110511194551.GD24245@mtj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-11-git-send-email-tj@kernel.org>
 <20110511164947.GA26383@redhat.com>
 <20110511170058.GB26383@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511170058.GB26383@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 11, 2011 at 07:00:58PM +0200, Oleg Nesterov wrote:
> On 05/11, Oleg Nesterov wrote:
> >
> > You know, I'd wish I could find the serious bugs in this patch. The
> > code becomes really hairy. -EAGAIN in do_wait() doesn't make it more
> > simple ;)
> 
> Mwahaha! I seem to see the bug ;)

:-)

> When the caller is do_wait(), we can't assume we are the tracer when
> we drop tasklist. Original tracer can detach, then another unrelated
> process can attach again and provoke JOBCTL_TRAPPING. wait_event()
> can hang forever.
> 
> Unfortunately, this is easy to fix :/

Yeah, it's basically the same problem raised in other two patches.
Making wait interruptible and clearing pending stop/traps on
detach/kill/cont/whatever should do the trick.  I'll reply the
previous message for the suggested change.

Thanks.

-- 
tejun
