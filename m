Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab2HGRiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:38:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39351 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab2HGRiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:38:24 -0400
Date: Tue, 7 Aug 2012 18:38:10 +0100
From: Will Deacon <will.deacon@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
Message-ID: <20120807173810.GE16877@mudshark.cambridge.arm.com>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208071259270.5231@xanadu.home>
 <20120807173344.GD16877@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807173344.GD16877@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 06:33:44PM +0100, Will Deacon wrote:
> What I think is happening is that B writes the -1 in __mutex_lock_common
> and, after seeing a NULL owner (C may not have set that yet), drops through
> to the:
> 
> 	if (atomic_xchg(&lock->count, -1) == 1)
> 		goto done;

Sorry, should have proofread that. I meant to say:

 What I think is happening is that B writes the -1 in __mutex_lock_common
 after seeing a NULL owner (C may not have set that yet) and dropping through
 to the:
 
 	if (atomic_xchg(&lock->count, -1) == 1)
 		goto done;
 

Will
