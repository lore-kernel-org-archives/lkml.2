Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2KLVxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:53:40 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51401 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2KLVxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:53:39 -0500
Date: Mon, 12 Nov 2012 13:53:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KY Srinivasan <kys@microsoft.com>
cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>
Subject: RE: [PATCH 1/1] mm: Export a function to read vm_committed_as
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930E35B45@SN2PRD0310MB382.namprd03.prod.outlook.com>
Message-ID: <alpine.DEB.2.00.1211121349130.23347@chino.kir.corp.google.com>
References: <1352600728-17766-1-git-send-email-kys@microsoft.com> <alpine.DEB.2.00.1211101830250.18494@chino.kir.corp.google.com> <426367E2313C2449837CD2DE46E7EAF930E35B45@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2012, KY Srinivasan wrote:

> Thanks for the prompt response. For the Linux balloon driver for Hyper-V, I need access
> to the metric that reflects the system wide memory commitment made by the guest kernel. 
> In the Hyper-V case, this information is one of the many metrics used to drive the policy engine
> on the host. Granted, the interface name I have chosen here could be more generic; how about
> read_mem_commit_info(void). I am open to suggestions here.
> 

I would suggest vm_memory_committed() and there shouldn't be a comment 
describing that this is just a wrapper for modules to read 
vm_committed_as, that's apparent from the implementation: it should be 
describing exactly what this value represents and why it is a useful 
metric (at least in the case that you're concerned about).

> With regards to making changes to the Xen self ballooning code, I would like to separate that patch
> from the patch that implements the exported mechanism to access the memory commitment information.

Why?  Is xen using it for a different inference?
