Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1CKAjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:39:17 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:37537 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab1CKAjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:39:15 -0500
Date: Fri, 11 Mar 2011 01:38:46 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: update for .39
Message-ID: <20110311003846.GA23548@linux-mips.org>
References: <4D790A13.4060705@caviumnetworks.com>
 <1299780241.15854.393.camel@gandalf.stny.rr.com>
 <20110310182000.GB2906@redhat.com>
 <1299782143.15854.402.camel@gandalf.stny.rr.com>
 <4D791CAA.7090108@caviumnetworks.com>
 <1299783236.15854.405.camel@gandalf.stny.rr.com>
 <4D791F31.6040100@caviumnetworks.com>
 <1299785143.15854.407.camel@gandalf.stny.rr.com>
 <1299786329.15854.409.camel@gandalf.stny.rr.com>
 <BLU0-SMTP39EE03AE86CF0F0E5C570596C80@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP39EE03AE86CF0F0E5C570596C80@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:22:14PM -0500, Mathieu Desnoyers wrote:

> You seem to be contradicting yourself here. I'm concerned about having
> "structures" of a size not power of two. Can we simply either
> 
> - Add a padding element at the end
> or
> - use .align 4*sizeof(long) at the beginning
> 
> to make sure the linker won't put any holes when it puts objects 
> together ?

It may only be a technicality but but careful with .align.  On some
architectures .align x will align to a multiple of x; on other
architectures to 2^x.  Another reason to stick to C wherever possible.

  Ralf
