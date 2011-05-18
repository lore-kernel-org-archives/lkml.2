Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1ERHGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:06:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754660Ab1ERHGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:06:01 -0400
Date: Wed, 18 May 2011 00:05:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] v6 Improve task->comm locking situation
Message-Id: <20110518000527.bcced636.akpm@linux-foundation.org>
In-Reply-To: <20110518062554.GB2945@elte.hu>
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
	<20110518062554.GB2945@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011 08:25:54 +0200 Ingo Molnar <mingo@elte.hu> wrote:

>   " Hey, this looks a bit racy and 'top' very rarely, on rare workloads that 
>     play with ->comm[], might display a weird reading task name for a second, 
>     amongst the many other temporarily nonsensical statistical things it 
>     already prints every now and then. "

Well we should at least make sure that `top' won't run off the end of
comm[] and go oops.  I think that's guaranteed by the fact(s) that
init_tasks's comm[15] is zero and is always copied-by-value across
fork and can never be overwritten in any task_struct.

But I didn't check that.

