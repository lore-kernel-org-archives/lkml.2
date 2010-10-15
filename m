Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab0JOOqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:46:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52672 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab0JOOqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Tx4IOu2opzH61+c6b8/hOilCobuXFNAetf/nxroLzW4t8kZSoA89nxbJpVotiLqL6r
         JaR9mnX57jRZAlcJitXfnb/w1ll1Ac65rYmkjjQbUU1fV80WJVuXvvTOWOTJQ/ge4NdZ
         BV6yQYgtWFkMyc4d+0grorNKzzGZH+rH+vXBo=
Subject: Re: [PATCH 3/8] Add a PF flag for ksoftirqd identification
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>
In-Reply-To: <1286237003-12406-4-git-send-email-venki@google.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
	 <1286237003-12406-4-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 16:46:28 +0200
Message-ID: <1287153988.2647.68.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 04 octobre 2010 à 17:03 -0700, Venkatesh Pallipadi a écrit :
> To account softirq time cleanly in scheduler, we need to identify whether
> softirq is invoked in ksoftirqd context or softirq at hardirq tail context.
> Add PF_KSOFTIRQD for that purpose.
> 
> As all PF flag bits are currently taken, create space by moving one of the
> infrequently used bits (PF_THREAD_BOUND) down in task_struct to be along
> with some other state fields.
> 
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>

Instead of using one bit per task (and fight to find a free bit) why not
using existing :

DEFINE_PER_CPU(struct task_struct *, ksoftirqd);

And check if current is ksoftirqd ?

if (__get_cpu_var(ksoftirqd) == current) ...


