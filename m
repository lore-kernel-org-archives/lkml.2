Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0HPO3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:29:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:58825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0HPO33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:29:29 -0400
Subject: Re: fix BUG: using smp_processor_id() in touch_nmi_watchdog and
 touch_softlockup_watchdog
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100816141250.GU4879@redhat.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
	 <1281946970.1926.998.camel@laptop> <20100816133452.GS4879@redhat.com>
	 <1281966418.1926.1421.camel@laptop>  <20100816141250.GU4879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 16:29:08 +0200
Message-ID: <1281968948.1926.1467.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 10:12 -0400, Don Zickus wrote:
> On Mon, Aug 16, 2010 at 03:46:58PM +0200, Peter Zijlstra wrote:
> > > I don't see a problem with the patch, but my low level understanding of
> > > the __get_cpu_var vs. per_cpu isn't very strong.
> > 
> > __get_cpu_var() gets you the value on the current cpu, per_cpu() takes a
> > cpu argument.
> 
> Well I know that much. :-)  It seems that __get_cpu_var depends on
> preemption being disabled whereas per_cpu does not?  Though for some
> reason I thought __get_cpu_var would be more atomic when it grabbed the
> current cpu such that you wouldn't need to disable preemption.  Guess not.

Indeed, it can't be implemented atomically on all smp systems, hence its
really nothing other than a 'convenient' short for per_cpu(foo,
smp_processor_id()).
