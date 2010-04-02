Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab0DBSeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:34:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0DBSdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:33:05 -0400
Date: Fri, 2 Apr 2010 20:30:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/4] oom: linux has threads
Message-ID: <20100402183057.GA31723@redhat.com>
References: <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com> <20100331175836.GA11635@redhat.com> <20100331204718.GD11635@redhat.com> <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com> <20100401135927.GA12460@redhat.com> <alpine.DEB.2.00.1004011210380.30661@chino.kir.corp.google.com> <20100402111406.GA4432@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402111406.GA4432@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Oleg Nesterov wrote:
>
> Once again:
>
> 	void *memory_hog_thread(void *arg)
> 	{
> 		for (;;)
> 			malloc(A_LOT);
> 	}
>
> 	int main(void)
> 	{
> 		pthread_create(memory_hog_thread, ...);
> 		syscall(__NR_exit, 0);
> 	}
>
> Now, even if we fix PF_EXITING check, select_bad_process() will always
> ignore this process. The group leader has ->mm == NULL.

So. Please see the COMPLETELY UNTESTED patches I am sending. They need
your review, or feel free to redo these fixes. 4/4 is a bit off-topic.

Also, please note the "This patch is not enough" comment in 3/4.

Oleg.

