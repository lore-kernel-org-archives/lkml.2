Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0LMU4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:56:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:29345 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab0LMU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:56:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=AepaXQXbEo6rAqR/B7wJh7kID7ovw6rCCxfSVxl0zG9WN2hz95W9n8/zTH0ugmFCRe
         Bd1j34PhhUaMM61j6jzQ==
Date: Mon, 13 Dec 2010 12:56:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [7/7,v8] NUMA Hotplug Emulator: Implement per-node add_memory
 debugfs interface
In-Reply-To: <20101213020924.GB19637@shaohui>
Message-ID: <alpine.DEB.2.00.1012131255580.13478@chino.kir.corp.google.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF2A40FED20A@shsmsx502.ccr.corp.intel.com> <20101209012124.GD5798@shaohui> <alpine.DEB.2.00.1012091325530.13564@chino.kir.corp.google.com> <20101209235705.GA10674@shaohui> <alpine.DEB.2.00.1012101529190.30039@chino.kir.corp.google.com>
 <20101213020924.GB19637@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Shaohui Zheng wrote:

> For the state transition to N_HIGH_MEMORY, it does not happen on the above too
> interfaces. It happens when the memory was onlined with sysfs /sys/device/system/memory/memoryXX/online
> interface.
> 
> That is the code path:
> store_mem_state
> 	->memory_block_change_state
> 	 	->memory_block_action
> 			->online_pages
> 
> 			if (onlined_pages) {
> 				kswapd_run(zone_to_nid(zone));
> 				node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
> 			}
> 
> does it address your question? thanks.
> 

Ok, thanks!
