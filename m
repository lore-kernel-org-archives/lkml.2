Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030473Ab2EQW2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:28:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38438 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224Ab2EQW17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:27:59 -0400
Message-ID: <1337293651.4281.114.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Fix broken strings in RCU's
 source code.
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Date: Fri, 18 May 2012 00:27:31 +0200
In-Reply-To: <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120517221217.GA12196@linux.vnet.ibm.com>
	 <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 15:12 -0700, Paul E. McKenney wrote:
>         cnt += sprintf(&page[cnt],
> -                      "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d "
> -                      "rtmbe: %d rtbke: %ld rtbre: %ld "
> -                      "rtbf: %ld rtb: %ld nt: %ld "
> -                      "onoff: %ld/%ld:%ld/%ld "
> -                      "barrier: %ld/%ld:%ld",

The paranoid side of me would've used:

	cnt += snprintf(page + cnt, PAGE_SIZE - cnt, ...);


