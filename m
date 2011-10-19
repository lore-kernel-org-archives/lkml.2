Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab1JSVTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:19:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60014 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1JSVTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:19:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ezVjh5BXPyEQgVUJ1f6cpLOHKdo4MrfpD/5e6QETI7Fq+pKnydnaqDFyv+cpUtIJl
	xYI1T3Y42p/ccDTz0RhcQ==
Date: Wed, 19 Oct 2011 14:19:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@amd64.org>
cc: EDAC devel <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] x86, RAS: Add attributes needed for HW injection
In-Reply-To: <20111019210946.GC7503@aftab>
Message-ID: <alpine.DEB.2.00.1110191415120.5687@chino.kir.corp.google.com>
References: <1319035866-29570-1-git-send-email-bp@amd64.org> <1319035866-29570-9-git-send-email-bp@amd64.org> <alpine.DEB.2.00.1110191402490.5687@chino.kir.corp.google.com> <20111019210946.GC7503@aftab>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Borislav Petkov wrote:

> > That wouldn't catch an offline cpuid, you probably want cpu_online(val)?
> 
> Good catch, thanks.
> 
> So I'm looking at <arch/x86/kernel/cpuid.c> which is how the validity of
> a cpu value should be tested properly, IMHO:
> 
> static int cpuid_open(struct inode *inode, struct file *file)
> {
> 	...
> 
> 	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
> 		return -ENXIO;	/* No such CPU */
> 	...

Right, the comment for cpumask_test_cpu(), which cpu_online() really is, 
wants a cpu < nr_cpu_ids.  
