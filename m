Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab2EaMPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:15:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:33532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2EaMPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:15:35 -0400
Message-ID: <1338466518.28384.57.camel@twins>
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
 is_swbp_insn() == T
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 31 May 2012 14:15:18 +0200
In-Reply-To: <1338400142.28384.12.camel@twins>
References: <20120530165757.GA8077@redhat.com>
	 <20120530165816.GA8085@redhat.com> <1338398931.28384.7.camel@twins>
	 <20120530173717.GM15587@linux.vnet.ibm.com>
	 <1338400142.28384.12.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 19:49 +0200, Peter Zijlstra wrote:
> 
> Oh, indeed. I overlooked copy_insn() is taking the page from the
> page-cache instead of the page-tables and will thus get the original.
> 

Related to this, what happens when we try to install a probe on a page
that's already been COWed by a ptrace user?

Say gdb did a code modification at or near the intended probe site.
