Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1CJRDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:03:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:55097 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab1CJRDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:03:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,297,1297065600"; 
   d="scan'208";a="718737000"
Date: Thu, 10 Mar 2011 09:03:45 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Paul Mundt <lethal@linux-sh.org>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] make *_gate_vma accept mm_struct instead of
 task_struct II
Message-ID: <20110310170345.GE20504@alboin.amr.corp.intel.com>
References: <1299630721-4337-1-git-send-email-wilsons@start.ca>
 <20110310160032.GA20504@alboin.amr.corp.intel.com>
 <20110310163809.GA20675@alboin.amr.corp.intel.com>
 <20110310165414.GA6431@fibrous.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310165414.GA6431@fibrous.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 11:54:14AM -0500, Stephen Wilson wrote:
> 
> On Thu, Mar 10, 2011 at 08:38:09AM -0800, Andi Kleen wrote:
> > On Thu, Mar 10, 2011 at 08:00:32AM -0800, Andi Kleen wrote:
> > > On Tue, Mar 08, 2011 at 07:31:56PM -0500, Stephen Wilson wrote:
> > > > The only architecture this change impacts in any significant way is x86_64.
> > > > The principle change on that architecture is to mirror TIF_IA32 via
> > > > a new flag in mm_context_t. 
> > > 
> > > The problem is -- you're adding a likely cache miss on mm_struct for
> > > every 32bit compat syscall now, even if they don't need mm_struct
> > > currently (and a lot of them do not) Unless there's a very good
> > > justification to make up for this performance issue elsewhere
> > > (including numbers) this seems like a bad idea.
> > 
> > Hmm I see you're only setting it on exec time actually on rereading
> > the patches. I thought you were changing TS_COMPAT which is in
> > the syscall path.
> > 
> > Never mind.  I have no problems with doing such a change on exec
> > time.
> 
> OK.  Great!  Does this mean I have your ACK'ed by or reviewed by?

I didn't read it all, but the first two patches looked ok.

-Andi
