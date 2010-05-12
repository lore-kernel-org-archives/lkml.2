Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0ELP7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:59:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab0ELP7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:59:00 -0400
Date: Wed, 12 May 2010 17:54:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@vnet.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] INIT_TASK() should initialize ->thread_group list
Message-ID: <20100512155453.GA20906@redhat.com>
References: <4BE01C86.3050908@secunet.com> <20100509184510.GA15219@redhat.com> <4BE7B3BD.70901@secunet.com> <20100510194917.GA5249@redhat.com> <20100510194949.GB5249@redhat.com> <20100512021537.GA11805@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512021537.GA11805@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Sukadev Bhattiprolu wrote:
>
> Oleg Nesterov [oleg@redhat.com] wrote:
> | The trivial /sbin/init doing
> |
> | 	int main(void)
> | 	{
> | 		kill(0, SIGKILL)
> | 	}
> |
> | crashes the kernel.
>
> Really subtle. Good catch.

Thanks to Mathias ;)

> So, now init is not part of any process group until it calls setsid().
> So the above SIGKILL is lost right ? - i.e it does not kill even init
> itself.

No, no. swapper != init. With or without these patches (more precisely,
the next patch) /sbin/init still belongs to the 0 pgrp/sid.

> In my quick test, the following init process lives on inspite of the
> SIGKILL.

Yes, /sbin/init is not killable, that is why it survies.

But:

> 	main()
> 	{
> 		kill(0, SIGKILL);
>
> 		while(1)
> 			sleep(1);
> 	}

Yes. if /sbin/init exits the kernel panics. The real test-case shouldn't
exit, like your example.

> I don't have a better solution. Maybe a hung init is better than a
> crashed kernel.

Agreed!!! I sent the patch a long ago. But security people do not
like it, they use exit() from init to provoke the crash intentionally.
And I still think they are wrong, but this is another story.

> Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Thanks!

Oleg.

