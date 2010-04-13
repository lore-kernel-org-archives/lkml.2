Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0DMIsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:48:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46046
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541Ab0DMIsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:48:18 -0400
Date: Tue, 13 Apr 2010 01:48:21 -0700 (PDT)
Message-Id: <20100413.014821.34906166.davem@davemloft.net>
To: imunsie@au1.ibm.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       mingo@elte.hu, acme@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       mitake@dcl.info.waseda.ac.jp, rusty@rustcorp.com.au, fweisbec@gmail.com,
       ebmunson@us.ibm.com, Valdis.Kletnieks@vt.edu, amwang@redhat.com,
       tfransosi@gmail.com, mhiramat@redhat.com, xiaoguangrong@cn.fujitsu.com,
       jaswinderrajput@gmail.com, arjan@linux.intel.com,
       hirofumi@mail.parknet.co.jp, efault@gmx.de, tzanussi@gmail.com,
       anton@samba.org, jkacur@redhat.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH] perf: Fix endianness argument compatibility
From: David Miller <davem@davemloft.net>
In-Reply-To: <1271147857-11604-1-git-send-email-imunsie@au.ibm.com>
References: <1271147857-11604-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ian Munsie" <imunsie@au1.ibm.com>
Date: Tue, 13 Apr 2010 18:37:33 +1000

> From: Ian Munsie <imunsie@au.ibm.com>
> 
> Parsing an option from the command line with OPT_BOOLEAN on a bool data
> type would not work on a big-endian machine due to the manner in which
> the boolean was being cast into an int and incremented. For example,
> running 'perf probe --list' on a PowerPC machine would fail to properly
> set the list_events bool and would therefore print out the usage
> information and terminate.
> 
> This patch makes OPT_BOOLEAN work as expected with a bool datatype. For
> cases where the original OPT_BOOLEAN was intentionally being used to
> increment an int each time it was passed in on the command line, this
> patch introduces OPT_INCR with the old behaviour of OPT_BOOLEAN (the
> verbose variable is currently the only such example of this).
> 
> I have reviewed every use of OPT_BOOLEAN to verify that a true C99 bool
> was passed. Where integers were used, I verified that they were only
> being used for boolean logic and changed them to bools to ensure that
> they would not be mistakenly used as ints. The major exception was the
> verbose variable which now uses OPT_INCR instead of OPT_BOOLEAN.
> 
> Signed-off-by: Ian Munsie <imunsie@au.ibm.com>

Thanks for finding and fixing this bug.
