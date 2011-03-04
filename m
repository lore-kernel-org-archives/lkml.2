Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266Ab1CDVdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:33:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37666 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760251Ab1CDVdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:33:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Fh5NXPpAv/g5BEHM2s0tM1qiV1pKcQkfBXP2V83sYRP8d9MrlTbhXouI/gknQ/+/sW
         yf1YxNXLkylAHf+ks8HA==
Date: Fri, 4 Mar 2011 13:33:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86-64, NUMA: Don't assume phys node 0 is always
 online in numa_emulation() handling
In-Reply-To: <20110304153106.GT20499@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1103041332001.3762@chino.kir.corp.google.com>
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com> <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org> <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com> <20110304153106.GT20499@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011, Tejun Heo wrote:

> Undetermined entries in emu_nid_to_phys[] are filled with zero
> assuming that physical node 0 is always online; however, this might
> not be true depending on hardware configuration.  Find a physical node
> which is actually online and use it instead.
> 

I still don't understand why emu_nid_to_phys[] can't return NUMA_NO_NODE 
and this needs to be done at all.  An emulated node should be mapped to a 
physical node based on the address ranges of that emulated node, so it's 
impossible for that to not map directly to a physical online node.  We 
don't support memoryless emulated nodes for hotpluggable SRAT entries.
