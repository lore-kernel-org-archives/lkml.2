Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0HPONN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:13:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0HPONM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:13:12 -0400
Date: Mon, 16 Aug 2010 10:12:50 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: fix BUG: using smp_processor_id() in touch_nmi_watchdog and
 touch_softlockup_watchdog
Message-ID: <20100816141250.GU4879@redhat.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
 <1281946970.1926.998.camel@laptop>
 <20100816133452.GS4879@redhat.com>
 <1281966418.1926.1421.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281966418.1926.1421.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 03:46:58PM +0200, Peter Zijlstra wrote:
> > I don't see a problem with the patch, but my low level understanding of
> > the __get_cpu_var vs. per_cpu isn't very strong.
> 
> __get_cpu_var() gets you the value on the current cpu, per_cpu() takes a
> cpu argument.

Well I know that much. :-)  It seems that __get_cpu_var depends on
preemption being disabled whereas per_cpu does not?  Though for some
reason I thought __get_cpu_var would be more atomic when it grabbed the
current cpu such that you wouldn't need to disable preemption.  Guess not.

Cheers,
Don

