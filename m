Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2JRD3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:29:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42341 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2JRD3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:29:05 -0400
Date: Wed, 17 Oct 2012 20:29:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tang Chen <tangchen@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's
 node.
In-Reply-To: <507F6EB3.7030705@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210172027210.32271@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <1349780256.7880.12.camel@twins> <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com> <1349815676.7880.85.camel@twins> <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
 <1349860216.7880.105.camel@twins> <alpine.DEB.2.00.1210101324000.28583@chino.kir.corp.google.com> <20121010133709.7eaefcdb.akpm@linux-foundation.org> <alpine.DEB.2.00.1210101351050.31237@chino.kir.corp.google.com> <alpine.DEB.2.00.1210171749150.20813@chino.kir.corp.google.com>
 <507F6EB3.7030705@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Tang Chen wrote:

> We are working on this problem. Since it is complicated, it really
> takes us some time. Sorry for the delay. :)
> 
> Actually, we intend to clear cpu-to-node mappings when a whole node is
> removed. But the node hot-plug code is still under development, so I
> think Wen will send a fix patch soon. :)
> 

Ok, thanks for the update.  I agree that we should be clearing the mapping 
at node hot-remove since any cpu that would subsequently get onlined and 
assume one of the previous cpu's ids is not guaranteed to have the same 
affinity.

I'm just really hoping that we don't touch the acpi code and that we can 
remove both cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch 
and cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch from 
-mm.

Thanks again!
