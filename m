Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab0LBCNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:13:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14711 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab0LBCNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:13:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=BsPkLIMrsckaEhjK3Gha1To2xWo16CncJL14tbgNz+XK84WlV7XlB6cWcidTP8htLq
         p169/xC3XxNQxPKnC2Tg==
Date: Wed, 1 Dec 2010 18:13:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org,
        Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Greg KH <gregkh@suse.de>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface
 for memory probe
In-Reply-To: <20101202002716.GA13693@shaohui>
Message-ID: <alpine.DEB.2.00.1012011807190.13942@chino.kir.corp.google.com>
References: <A24AE1FFE7AEC5489F83450EE98351BF288D88D224@shsmsx502.ccr.corp.intel.com> <20101202002716.GA13693@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, Shaohui Zheng wrote:

> so we should still keep the sysfs memory/probe interface without any modifications,
> but for the debugfs mem_hotplug/probe interface, we can add the memory region 
> to a desired node.

This feature would be distinct from the add_node interface already 
provided: instead of hotplugging a new node to test the memory hotplug 
callbacks, this new interface would only be hotadding new memory to a node 
other than the one it has physical affinity with.  For that support, I'd 
suggest new probe files in debugfs for each online node:

	/sys/kernel/debug/mem_hotplug/add_node (already exists)
	/sys/kernel/debug/mem_hotplug/node0/add_memory
	/sys/kernel/debug/mem_hotplug/node1/add_memory
	...

and then you can offline and remove that memory with the existing hotplug 
support (CONFIG_MEMORY_HOTPLUG and CONFIG_MEMORY_HOTREMOVE, respectively).
