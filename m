Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab0GGPll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:41:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:54983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab0GGPlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:41:40 -0400
Subject: Re: [PATCH v4 03/12] Add async PF initialization to PV guest.
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       riel@redhat.com, cl@linux-foundation.org, mtosatti@redhat.com
In-Reply-To: <1278433500-29884-4-git-send-email-gleb@redhat.com>
References: <1278433500-29884-1-git-send-email-gleb@redhat.com>
	 <1278433500-29884-4-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 07 Jul 2010 17:41:01 +0200
Message-ID: <1278517261.1946.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 19:24 +0300, Gleb Natapov wrote:
> @@ -329,6 +330,8 @@ notrace static void __cpuinit start_secondary(void *unused)
>         per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
>         x86_platform.nmi_init();
>  
> +       kvm_guest_cpu_init();
> +
>         /* enable local interrupts */
>         local_irq_enable(); 

CPU_STARTING hotplug notifier is too early?

called from:
   start_secondary()
     smp_callin()
       notify_cpu_starting() 

