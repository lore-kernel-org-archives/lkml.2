Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab0JRUsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:48:06 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59690 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0JRUsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ufcS+kFZqr5dZkAoRb/xvXei30F6XVQxrlsUfkh4TWVdoewrR5IwxjtRYOjhIwt5Jg
         labOcsKiRm0tC67QcAvQ==
Date: Mon, 18 Oct 2010 13:47:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
In-Reply-To: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.1010181340080.10965@chino.kir.corp.google.com>
References: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Frederic Weisbecker wrote:

> 9, 19 and 26 values are missing from the TIF shift range, probably
> due to flags that were removed by the past. Now repack the range
> so that we can quickly retrieve the remaining free shift slots.
> 
> But take care of keeping the seperation between high and low bits
> as some masks are created on top of this boundary.
> 

What's the benefit of doing this?

These flags are exported to userspace through SysRq-T, SysRq+W, the hung 
task detector, and the rcu stall detector, so there may be external 
dependencies testing for these bits.

We use this to look for TIF_MEMDIE to determine whether an oom killed task 
has failed to exit and becomes hung after having access to memory 
reserves, and that's one of the bits you've changed here.
