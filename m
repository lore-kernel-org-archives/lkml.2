Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2BOUsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:48:01 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43765 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2BOUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:48:00 -0500
Date: Wed, 15 Feb 2012 20:47:57 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
Message-ID: <20120215204757.GA30275@srcf.ucam.org>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
 <alpine.LFD.2.02.1202151537500.2794@ionos>
 <20120215145225.GA21448@srcf.ucam.org>
 <alpine.LFD.2.02.1202152059230.2794@ionos>
 <20120215202221.GA29552@srcf.ucam.org>
 <alpine.LFD.2.02.1202152125500.2794@ionos>
 <20120215203814.GA29795@srcf.ucam.org>
 <alpine.LFD.2.02.1202152140110.2794@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1202152140110.2794@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 09:46:27PM +0100, Thomas Gleixner wrote:

> Dammit, we cannot come up with a reasonable definition for special
> casing that stuff simply because you cannot draw a clear boundary what
> to special case and what not. And there is no sensible definition for
> what to do - return right away or go through schedule() or what ever.
> 
> sleep(0) is as pointless as sched_yield() and it's about time that we
> stop to create a fucking mess in the kernel just because user space
> programmers refuse to understand how an operating system works and how
> proper programming should be done.

Ok. I'll work on finding how prevelant it is and see if we can kill it 
off in userspace.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
