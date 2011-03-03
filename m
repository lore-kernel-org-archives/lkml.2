Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab1CCUEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:04:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14755 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab1CCUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:04:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=J155sn9ch7P2On3tZ/LYDBFKz4fh6i/rehg+YS9nbaFMC0c5h4p1OUueMOEqFuphWK
         +/S/7dh72IlNUJhs4fzA==
Date: Thu, 3 Mar 2011 12:04:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
In-Reply-To: <4D6EB2C3.7040704@kernel.org>
Message-ID: <alpine.DEB.2.00.1103031201180.9993@chino.kir.corp.google.com>
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com> <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org> <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com> <20110302154215.GN3319@htj.dyndns.org> <4D6EB2C3.7040704@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Yinghai Lu wrote:

> BTW: this conf get broken several times, and get fixed several times.
> 

Yes, it has been.  I think it's because there's an assumption that if the 
NUMA initialization fails that we automatically fake a single node 0 
covering all RAM.  The pxm for node 0 doesn't actually need to have any 
memory bound to it in the SRAT, so it is trivial with a custom BIOS to 
avoid onlining the node.  There doesn't appear to be any other problems 
related to this that we run into throughout the kernel, but it certainly 
needs to be fixed in this new emulation code even if those fake-to-phys 
mappings aren't currently used because it's a bad assumption.
