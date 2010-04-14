Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0DNVJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:09:36 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:32197 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab0DNVJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:09:34 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMrLxUurRN+K/2dsb2JhbACbWHGjdJoGhQ0E
X-IronPort-AV: E=Sophos;i="4.52,206,1270425600"; 
   d="scan'208";a="250495281"
Message-ID: <4BC62F0C.5070606@cisco.com>
Date: Wed, 14 Apr 2010 17:09:32 -0400
From: David VomLehn <dvomlehn@cisco.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Russell King <rmk@arm.linux.org.uk>, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
References: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>	<20100412122745.GC28208@flint.arm.linux.org.uk> <20100412153557.42b3155a@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100412153557.42b3155a@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> On Mon, 12 Apr 2010 13:27:45 +0100
> Russell King <rmk@arm.linux.org.uk> wrote:
>
>   
>> On Sun, Apr 11, 2010 at 11:06:09PM -0700, David VomLehn wrote:
>>     
>>> This patch makes panic() and die() registers available to, for example,
>>> panic notifier functions.  Panic notifier functions are quite useful
>>> for recording crash information, but they don't get passed the register
>>> values. This makes it hard to print register contents, do stack
>>> backtraces, etc. The changes in this patch save the register state when
>>> panic() is called and introduce a function for die() to call that allows
>>> it to pass in the registers it was passed.
>>>       
>> Can you explain why you want this?
>>
>> I'm wondering about the value of saving the registers; normally when a panic
>> occurs, it's because of a well defined reason, and not because something
>> went wrong in some CPU register; to put it another way, a panic() is a
>> more controlled exception than a BUG() or a bad pointer dereference.
>>     
>
> I'm curious about the potential use case as well. So far I only wanted
> to know the registers if the panic has been triggered due to an
> unexpected fault with panic_on_oops=1 or in_interrupt()==1. If that
> happens the die() handler prints the registers. An open coded panic is
> easy to analyze, imho no need for the registers
>   

Good example, because helps focus the issue. In recording a subset of 
kernel state
information from an embedded system for collection at a central point. 
The register
values printed by die() are printed to the console, where they 
disappear. One of the
things in this patch involves passed a pointer to those die() registers 
to a register
panic notifier handler. So, there is a path to where panic handlers are 
called from
die() and another one from panic() and this patch makes register values 
available in
both cases.
