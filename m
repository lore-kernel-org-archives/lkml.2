Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2BOUiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:38:21 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49827 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2BOUiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:38:16 -0500
Date: Wed, 15 Feb 2012 20:38:14 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
Message-ID: <20120215203814.GA29795@srcf.ucam.org>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
 <alpine.LFD.2.02.1202151537500.2794@ionos>
 <20120215145225.GA21448@srcf.ucam.org>
 <alpine.LFD.2.02.1202152059230.2794@ionos>
 <20120215202221.GA29552@srcf.ucam.org>
 <alpine.LFD.2.02.1202152125500.2794@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1202152125500.2794@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 09:30:20PM +0100, Thomas Gleixner wrote:
> On Wed, 15 Feb 2012, Matthew Garrett wrote:
> > Excellent. So the real question is what /should/ sleep(0) do - nothing, 
> > schedule or sleep for an arbitrary period of time that could be years?
> 
> Well, I don't expect slack to be set to years and I really don't want
> to special case sleep(0), because then we might end up discussing
> special casing usleep(1) or nanosleep(1ns) as well.

Increasing slack to the seconds range has measureable power management 
benefits, but there's some code that ends up broken as a result even 
when they're nominally event driven. I've no problem with us just 
declaring that code as broken, but it would be less effort to special 
case it. Application authors do seem to have ended up under the belief 
that sleep(0) is a meaningful thing to do, and the internet seems to be 
full of suggestions to use it rather than sched_yield().

-- 
Matthew Garrett | mjg59@srcf.ucam.org
