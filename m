Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031049Ab2ERNiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:38:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:57431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2ERNiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:38:03 -0400
Message-ID: <1337348267.573.37.camel@twins>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 18 May 2012 15:37:47 +0200
In-Reply-To: <20120518125505.GK20215@aftab.osrc.amd.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
	 <1332340496-21658-2-git-send-email-bp@amd64.org>
	 <1337336040.573.12.camel@twins> <20120518110357.GH20215@aftab.osrc.amd.com>
	 <1337340263.573.31.camel@twins> <20120518115957.GB19785@gmail.com>
	 <20120518125505.GK20215@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 14:55 +0200, Borislav Petkov wrote:
> It is an interesting question how we handle that RO/RW thing?

RO buffers overwrite, RW buffers loose events.

We could allow both for persistent under the constraints:

 VM_SHARED - must imply !VM_WRITE since multiple people writing to the
             control page will get 'interesting' very fast.

 !VM_SHARED - must fail mmap() of the debugfs file if there's already
              an existing user.

Note that even RW buffers only allows writes to the control page, a
write to the actual data itself will generate a fault.
