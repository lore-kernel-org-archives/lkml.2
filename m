Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab0JRVah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:30:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22630 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630Ab0JRVaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=PWgtdbHzJDZhuQ/ksmYjXiAyfuv6nA5n4liCJiT5j9XB4CWQuHCkt1dE3USNnkcYpY
         O3498SbuNQbeLwLSbblg==
Date: Mon, 18 Oct 2010 14:30:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
In-Reply-To: <alpine.LFD.2.00.1010182320440.6815@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.00.1010181430220.15782@chino.kir.corp.google.com>
References: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com> <alpine.DEB.2.00.1010181340080.10965@chino.kir.corp.google.com> <alpine.LFD.2.00.1010182320440.6815@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Thomas Gleixner wrote:

> I agree in general, but this is stupid as hell. No fcking interface
> should exposed kernel internal flag bits just as hex values and no
> fcking luser space should rely on it to be a subject of no change.
> 
> Seriously, if we can't even change TIF_* bits anymore then we are
> doing something wrong. That's a pure kernel internal affair and
> subject to change.
> 

I agree, and when I added them to the show_state() dumps, I should have 
probably enumerated the bits of interest to userspace and printed them 
much like taint flags: use 'M' for my bit of interest, TIF_MEMDIE, which 
gives access to memory reserves.  We care a _lot_ about detecting hung 
tasks that have that bit set because it usually indicates a VM problem 
where we've allowed complete depletion of memory reserves.  There's no 
other way to detect that, so we need to export TIF_MEMDIE somehow and if 
that's by doing (ti->flags & TIF_MEMDIE) ? "M" : "" then that's fine by 
me.  I hope we can do that before changing its value, though.
