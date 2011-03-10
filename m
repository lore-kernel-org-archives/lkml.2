Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1CJQzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:55:31 -0500
Received: from mout.perfora.net ([74.208.4.195]:64070 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab1CJQz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:55:27 -0500
Date: Thu, 10 Mar 2011 11:54:14 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Andi Kleen <ak@linux.intel.com>
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
Message-ID: <20110310165414.GA6431@fibrous.localdomain>
References: <1299630721-4337-1-git-send-email-wilsons@start.ca> <20110310160032.GA20504@alboin.amr.corp.intel.com> <20110310163809.GA20675@alboin.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310163809.GA20675@alboin.amr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:HxHmOb3FHJqNhbWPaTuXsrE0XBJmbQaSWdTHluSalcM
 CSXFMGTVUkUsPQTam8JD43TuBaWUWs2cNNXGj6+uv8hq57IK1/
 FPCdEIWYs0lvj6PtPNqjMW6WstYn/s0gX7kJdfRWZVrMwNKYgu
 pwXOHrUhXiOhp1iUiXDh4DjAMa0/7WZRXGPgjiu5sFzB5/xRvk
 hxe9qbGMQG4cZGS4YryUqUxU7ZIDR6WisnVogc18vs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Mar 10, 2011 at 08:38:09AM -0800, Andi Kleen wrote:
> On Thu, Mar 10, 2011 at 08:00:32AM -0800, Andi Kleen wrote:
> > On Tue, Mar 08, 2011 at 07:31:56PM -0500, Stephen Wilson wrote:
> > > The only architecture this change impacts in any significant way is x86_64.
> > > The principle change on that architecture is to mirror TIF_IA32 via
> > > a new flag in mm_context_t. 
> > 
> > The problem is -- you're adding a likely cache miss on mm_struct for
> > every 32bit compat syscall now, even if they don't need mm_struct
> > currently (and a lot of them do not) Unless there's a very good
> > justification to make up for this performance issue elsewhere
> > (including numbers) this seems like a bad idea.
> 
> Hmm I see you're only setting it on exec time actually on rereading
> the patches. I thought you were changing TS_COMPAT which is in
> the syscall path.
> 
> Never mind.  I have no problems with doing such a change on exec
> time.

OK.  Great!  Does this mean I have your ACK'ed by or reviewed by?


Thanks for taking a look!

-- 
steve

