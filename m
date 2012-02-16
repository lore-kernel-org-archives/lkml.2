Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2BPO1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:27:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49851 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2BPO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:27:38 -0500
Date: Thu, 16 Feb 2012 14:27:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
Message-ID: <20120216142733.GA15632@srcf.ucam.org>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
 <alpine.LFD.2.02.1202151537500.2794@ionos>
 <20120215145225.GA21448@srcf.ucam.org>
 <alpine.LFD.2.02.1202152059230.2794@ionos>
 <20120215202221.GA29552@srcf.ucam.org>
 <alpine.LFD.2.02.1202152125500.2794@ionos>
 <20120215203814.GA29795@srcf.ucam.org>
 <alpine.LFD.2.02.1202152140110.2794@ionos>
 <20120215204757.GA30275@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215204757.GA30275@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 08:47:57PM +0000, Matthew Garrett wrote:

> Ok. I'll work on finding how prevelant it is and see if we can kill it 
> off in userspace.

Checking through an exploded Fedora kernel tree suggests around 125 
packages out of 11000 or so, so around 1% of userspace seems to use 
sleep(0) under certain circumstances. We can probably fix everything in 
the distribution, but that suggests that there's also going to be a 
significant amount of code in the outside world that's also broken. 

Userspace clearly has an expectation that sleep(0) is magic in some 
ill-defined way. We'd be well within our rights to break that 
expectation, but I think it's common enough to warrant special casing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
