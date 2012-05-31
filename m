Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2EaM4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:56:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44547 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab2EaM4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:56:45 -0400
Date: Thu, 31 May 2012 18:24:11 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
 is_swbp_insn() == T
Message-ID: <20120531125411.GA24279@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120530165757.GA8077@redhat.com>
 <20120530165816.GA8085@redhat.com>
 <1338398931.28384.7.camel@twins>
 <20120530173717.GM15587@linux.vnet.ibm.com>
 <1338400142.28384.12.camel@twins>
 <1338466518.28384.57.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338466518.28384.57.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053112-1780-0000-0000-000006096C28
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000279; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00143966; UDB=6.00033088; UTC=2012-05-31
 12:56:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-05-31 14:15:18]:

> On Wed, 2012-05-30 at 19:49 +0200, Peter Zijlstra wrote:
> > 
> > Oh, indeed. I overlooked copy_insn() is taking the page from the
> > page-cache instead of the page-tables and will thus get the original.
> > 
> 
> Related to this, what happens when we try to install a probe on a page
> that's already been COWed by a ptrace user?
> 
> Say gdb did a code modification at or near the intended probe site.
> 

If the page is already COWED because of an existing code modification
near the intended probe site, we are replacing it with another page
keeping the previous modification as is.

ptrace and uprobes tracing the same instruction wont work cleanly for
now.

-- 
thanks and regards
Srikar

