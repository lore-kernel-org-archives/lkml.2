Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab0ELQHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 12:07:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab0ELQHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 12:07:04 -0400
Date: Wed, 12 May 2010 18:03:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@vnet.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] pids: init_struct_pid.tasks should never see the
	swapper process
Message-ID: <20100512160359.GB20906@redhat.com>
References: <4BE01C86.3050908@secunet.com> <20100509184510.GA15219@redhat.com> <4BE7B3BD.70901@secunet.com> <20100510194917.GA5249@redhat.com> <20100510195014.GC5249@redhat.com> <20100511095410.GA27850@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511095410.GA27850@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> > Change INIT_STRUCT_PID/INIT_PID_LINK to create the empty/unhashed
> > hlist_head/hlist_node. Like any other idle thread swapper can never exit,
> > so detach_pid()->__hlist_del() is not possible, but we could change
> > INIT_PID_LINK() to set pprev = &next if needed.
> >
> > All we need is the valid swapper->pids[].pid == &init_struct_pid.
> >
> > Reported-by: Mathias Krause <mathias.krause@secunet.com>
>
> Crimey, trying to find some way this could get dereferenced,

Yes, I was worried too. But afaics we should never use this hlist_node.
Except, of course, it is linked into pid->task.

> finding
> myself impressed with the likes of set_ftrace_swapper().
>
> Anyway, not finding anything, so
>
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Acked-by: Serge E. Hallyn <serue@us.ibm.com>

Thanks for review!

Oleg.

