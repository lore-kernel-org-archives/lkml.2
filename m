Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab0LJXaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:30:52 -0500
Received: from smtp-out.google.com ([74.125.121.35]:61209 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0LJXav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:30:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sHNcyBThtjTEM6Toa15V2c2pI2PMONz/Kezf/xoNk9Gl12gYLFCo4VwwFOmxKiDKqs
         SiX/CJk+9Li1qPeP0mUQ==
Date: Fri, 10 Dec 2010 15:30:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [7/7,v8] NUMA Hotplug Emulator: Implement per-node add_memory
 debugfs interface
In-Reply-To: <20101209235705.GA10674@shaohui>
Message-ID: <alpine.DEB.2.00.1012101529190.30039@chino.kir.corp.google.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF2A40FED20A@shsmsx502.ccr.corp.intel.com> <20101209012124.GD5798@shaohui> <alpine.DEB.2.00.1012091325530.13564@chino.kir.corp.google.com> <20101209235705.GA10674@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Shaohui Zheng wrote:

> > That doesn't address the question.  My question is whether or not adding 
> > memory to a memoryless node in this way transitions its state to 
> > N_HIGH_MEMORY in the VM?
> I guess that you are talking about memory hotplug on x86_32, memory hotplug is
> NOT supported well for x86_32, and the function add_memory does not consider
> this situlation.
> 
> For 64bit, N_HIGH_MEMORY == N_NORMAL_MEMORY, so we need not to do the transition.
> 

One more time :)  Memoryless nodes do not have their bit set in 
N_HIGH_MEMORY.  When memory is added to a memoryless node with this new 
interface, does the bit get set?
