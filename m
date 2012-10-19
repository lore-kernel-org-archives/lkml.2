Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab2JSLSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:18:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:47345 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2JSLSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:18:21 -0400
Message-ID: <1350645484.30157.3.camel@twins>
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
        miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Date: Fri, 19 Oct 2012 13:18:04 +0200
In-Reply-To: <alpine.DEB.2.00.1210172027210.32271@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1349780256.7880.12.camel@twins>
	 <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com>
	 <1349815676.7880.85.camel@twins>
	 <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
	 <1349860216.7880.105.camel@twins>
	 <alpine.DEB.2.00.1210101324000.28583@chino.kir.corp.google.com>
	 <20121010133709.7eaefcdb.akpm@linux-foundation.org>
	 <alpine.DEB.2.00.1210101351050.31237@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1210171749150.20813@chino.kir.corp.google.com>
	 <507F6EB3.7030705@cn.fujitsu.com>
	 <alpine.DEB.2.00.1210172027210.32271@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 20:29 -0700, David Rientjes wrote:
> 
> Ok, thanks for the update.  I agree that we should be clearing the mapping 
> at node hot-remove since any cpu that would subsequently get onlined and 
> assume one of the previous cpu's ids is not guaranteed to have the same 
> affinity.

Would this mean we have to remap (and memcpy) per-cpu memory on
node-plug?

> I'm just really hoping that we don't touch the acpi code and that we can 
> remove both cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch 
> and cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch from 
> -mm.

Yeah, none of this should be anywhere near ACPI, its got nothing to do
with ACPI. Furthermore it should be be same across all archs, not just
be weird and wonderful for x86.


