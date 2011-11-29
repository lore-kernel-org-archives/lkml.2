Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1K2UJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:09:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:8945 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260Ab1K2UJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:09:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,592,1315206000"; 
   d="scan'208";a="42226817"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
Subject: Re: Perhaps a side effect regarding NMI returns
References: <1322539673.17003.45.camel@frodo>
	<CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
Date: Tue, 29 Nov 2011 12:09:47 -0800
In-Reply-To: <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 28 Nov 2011 20:53:55 -0800")
Message-ID: <m2r50qlmgk.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

Not sure what problem Steven thinks is there. Once you 
switched the stack any nesting is fine.

> I would suggest that the actual NMI handler itself should probably
> never use that paranoid exit at all, and just always use a regular
> iret. Screw scheduling and TIF checks.

The reason I added them originally is to prevent the race of remote
kernel events being delayed for a long time. With Frederic's nohz work
this will be more important in the future. Today it would be eventually
picked up by the regular timer interrupts.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
