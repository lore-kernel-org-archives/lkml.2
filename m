Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab2EaPMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:12:52 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44913 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab2EaPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:12:51 -0400
Date: Thu, 31 May 2012 20:37:56 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH 1/3] uprobes/core: Remove redundant
 lock_page/unlock_page
Message-ID: <20120531150756.GC24279@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
 <1338465518.28384.55.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338465518.28384.55.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053115-5518-0000-0000-000004D00046
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-05-31 13:58:38]:

> On Thu, 2012-05-31 at 17:16 +0530, Srikar Dronamraju wrote:
> > From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > 
> > No need to lock the page when copying the opcode in read_opcode().
> 
> It would be good if the changelog said _why_ this is so :-)

In read_opcode(), we have the reference for the page and we only are reading
from the the page. i.e we are neither modifying the page contents, not
the page attributes. 

Existing kernel code has enough examples where we read the contents
of the page without taking the page lock.

Further this was discussed here too https://lkml.org/lkml/2012/4/17/361.

-- 
Thanks and Regards
Srikar

