Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0FWUXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:23:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:18385 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab0FWUXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BfuZ2Qn/obgcaZw20fRFfmxxLpp1gOE0X/VxitftWkTfVCs01lKw9DsmJ12k/kGYDx
         0JrwfMZna6taU3mMii03BB8EHFYDZofmzky8TliraB5sxlRB5P7rICXKqTuhf+JeEF66
         FMJJfiOIZGiFsfwBS5QMr4gWWq2RiICwyQDz8=
Date: Wed, 23 Jun 2010 23:23:35 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100623202335.GA4424@x200>
References: <20100623181129.GM5876@outflux.net>
 <20100623194145.GA19628@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623194145.GA19628@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 09:41:45PM +0200, Oleg Nesterov wrote:
> On 06/23, Kees Cook wrote:
 
> > -extern char *get_task_comm(char *to, struct task_struct *tsk);
> > +#define get_task_comm(buf, task) get_task_comm_size(buf, sizeof(buf), task)
> > +extern char *get_task_comm_size(char *to, size_t len, struct task_struct *tsk);
> 
> Oh, but this means that get_task_comm(ptr, task) doesn't work?

The number of users is so small, and everyone uses TASK_COMM_LEN,
so maybe nothing should be done or "char buf[TASK_COMM_LEN]"?
