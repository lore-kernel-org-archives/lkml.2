Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2BOUWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:22:24 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59550 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2BOUWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:22:23 -0500
Date: Wed, 15 Feb 2012 20:22:21 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
Message-ID: <20120215202221.GA29552@srcf.ucam.org>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
 <alpine.LFD.2.02.1202151537500.2794@ionos>
 <20120215145225.GA21448@srcf.ucam.org>
 <alpine.LFD.2.02.1202152059230.2794@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1202152059230.2794@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 09:14:30PM +0100, Thomas Gleixner wrote:

> Just for the extended fun of it: The pre hrtimer implementation in
> Linux put the task on sleep as well up to the next jiffies boundary,
> so anything which used sleep(0) on a pre hrtimer kernel was going to
> sleep. That's also the case today when high resolution timers are
> disabled (compile or runtime).
> 
> So anything which relies on sleep(0) as a fast scheduling point is and
> has been broken forever.

Excellent. So the real question is what /should/ sleep(0) do - nothing, 
schedule or sleep for an arbitrary period of time that could be years?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
