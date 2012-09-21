Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab2IUWIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595Ab2IUWI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:08:29 -0400
Date: Fri, 21 Sep 2012 18:08:18 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
Message-ID: <20120921220818.GA30959@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
	Matt Fleming <matt.fleming@intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 12:43:04PM -0700, H. Peter Anvin wrote:
 > Supervisor Mode Access Prevention (SMAP) is a new security feature
 > disclosed by Intel in revision 014 of the Intel® Architecture
 > Instruction Set Extensions Programming Reference:
 > 
 > http://software.intel.com/sites/default/files/319433-014.pdf
 > 
 > When SMAP is active, the kernel cannot normally access pages that are
 > user space (U=1).  Since the kernel does have the need to access user
 > space pages under specific circumstances, an override is provided: the
 > kernel can access user space pages if EFLAGS.AC=1.  For system data
 > structures, e.g. descriptor tables, that are accessed by the processor
 > directly, SMAP is active even in CPL 3 regardless of EFLAGS.AC.
 > 
 > SMAP also includes two new instructions, STAC and CLAC, to flip the AC
 > flag more quickly.

Perhaps add a printk somewhere to show that it's actually been enabled maybe ?

Also, would it be feasible to add something like we have for test_nx ?
If this feature regresses in some way in the future, I suspect we'd like
to know about it sooner rather than later.

	Dave

