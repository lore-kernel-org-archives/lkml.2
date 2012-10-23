Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965443Ab2JWU5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:57:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:50308 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965377Ab2JWU51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:57:27 -0400
Message-ID: <1351025831.13456.43.camel@twins>
Subject: Re: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 23 Oct 2012 22:57:11 +0200
In-Reply-To: <20121023192318.GA25872@redhat.com>
References: <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
	 <20121017165902.GB9872@redhat.com>
	 <20121017224430.GC2518@linux.vnet.ibm.com>
	 <20121018162409.GA28504@redhat.com>
	 <20121018163833.GK2518@linux.vnet.ibm.com>
	 <20121018175747.GA30691@redhat.com>
	 <20121019192838.GM2518@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
	 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
	 <20121023165912.GA18712@redhat.com> <20121023192318.GA25872@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 21:23 +0200, Oleg Nesterov wrote:
> 
>         static void mb_ipi(void *arg)
>         {
>                 smp_mb(); /* unneeded ? */
>         }
> 
>         static void force_mb_on_each_cpu(void)
>         {
>                 smp_mb();
>                 smp_call_function(mb_ipi, NULL, 1);
>         } 

You know we're spending an awful lot of time and effort to get rid of
such things, right? RT and HPC people absolutely hate these random IPI
things.
