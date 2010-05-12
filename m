Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab0ELCKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:10:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45703 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab0ELCKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:10:04 -0400
Date: Tue, 11 May 2010 19:15:37 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@vnet.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] INIT_TASK() should initialize ->thread_group list
Message-ID: <20100512021537.GA11805@us.ibm.com>
References: <4BE01C86.3050908@secunet.com> <20100509184510.GA15219@redhat.com> <4BE7B3BD.70901@secunet.com> <20100510194917.GA5249@redhat.com> <20100510194949.GB5249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510194949.GB5249@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| The trivial /sbin/init doing
| 
| 	int main(void)
| 	{
| 		kill(0, SIGKILL)
| 	}
| 
| crashes the kernel.

Really subtle. Good catch.

So, now init is not part of any process group until it calls setsid().
So the above SIGKILL is lost right ? - i.e it does not kill even init
itself.

In my quick test, the following init process lives on inspite of the
SIGKILL.

	main()
	{
		kill(0, SIGKILL);

		while(1)
			sleep(1); 
	}

I don't have a better solution. Maybe a hung init is better than a
crashed kernel. the patches look good.

Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
