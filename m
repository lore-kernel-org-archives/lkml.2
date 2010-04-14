Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0DNKAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:00:06 -0400
Received: from peff.net ([208.65.91.99]:37135 "EHLO peff.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab0DNKAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:00:04 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2010 06:00:04 EDT
Date: Wed, 14 Apr 2010 05:52:52 -0400
From: Jeff King <peff@peff.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, git@vger.kernel.org,
       imunsie@au1.ibm.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, paulus@samba.org, acme@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, mitake@dcl.info.waseda.ac.jp,
       rusty@rustcorp.com.au, fweisbec@gmail.com, ebmunson@us.ibm.com,
       Valdis.Kletnieks@vt.edu, amwang@redhat.com, tfransosi@gmail.com,
       mhiramat@redhat.com, xiaoguangrong@cn.fujitsu.com,
       jaswinderrajput@gmail.com, arjan@linux.intel.com,
       hirofumi@mail.parknet.co.jp, efault@gmx.de, tzanussi@gmail.com,
       anton@samba.org, jkacur@redhat.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH] perf: Fix endianness argument compatibility
Message-ID: <20100414095252.GA17884@coredump.intra.peff.net>
References: <1271147857-11604-1-git-send-email-imunsie@au.ibm.com>
 <20100413.014821.34906166.davem@davemloft.net>
 <20100414092843.GD10537@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100414092843.GD10537@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 11:28:43AM +0200, Ingo Molnar wrote:

> > > Parsing an option from the command line with OPT_BOOLEAN on a bool data
> > > type would not work on a big-endian machine due to the manner in which
> > > the boolean was being cast into an int and incremented. For example,
> > > running 'perf probe --list' on a PowerPC machine would fail to properly
> > > set the list_events bool and would therefore print out the usage
> > > information and terminate.
> [...]
>
> Nice fix!
> 
> Btw., perf got the option parser from the Git project - i'm wondering how the 
> Git folks solved this endianness problem?

We didn't. We pass only actual ints for the value field in all cases. We
don't use C99 bools at all. We do use bit-fields, but the compiler
catches the error, since OPT_BOOLEAN tries to take its address.

-Peff
