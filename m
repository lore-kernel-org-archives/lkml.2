Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0LaXJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 18:09:26 -0500
Received: from smtp-out.google.com ([74.125.121.67]:45903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab0LaXJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 18:09:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=e2y9ulEDfORwEMx/rE0OMbXZFepJBTsOBK7J9l0oTjx4c8A3WCqkN1D/aSuEPhUu/B
         OVqfia5rl5ptPJyQzBug==
Date: Fri, 31 Dec 2010 15:09:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 15/16] x86: Unify node_to_cpumask_map handling between
 32 and 64bit
In-Reply-To: <20101231132034.GK18831@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1012311504420.13148@chino.kir.corp.google.com>
References: <1293536929-31683-1-git-send-email-tj@kernel.org> <1293536929-31683-16-git-send-email-tj@kernel.org> <alpine.DEB.2.00.1012281240000.8883@chino.kir.corp.google.com> <20101230124800.GD18831@htj.dyndns.org> <20101230145858.GE18831@htj.dyndns.org>
 <alpine.DEB.2.00.1012301028590.12207@chino.kir.corp.google.com> <20101231132034.GK18831@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010, Tejun Heo wrote:

> > (and the unification that can be done in the meantime would only be the 
> > actual apicid-to-node and pxm-to-node mappings after it is exported from 
> > amd and acpi specific functions), so I'd prefer to handle cleanups as 
> > incremental patches on top of those.
> 
> The problem is that those "incremental" patches often don't happen
> once the itch is gone while the immediate fixes/improvements aggravate
> existing complications.  If you were/are planning to clean it up, I
> have nothing to whine about.  :-)
> 

We can certainly implement i386 NUMA emulation after the unification is 
done (only to avoid additional conflicts on your set :), but I'm not sure 
if there's an audience of testers and debuggers who want to use it for 
i386 NUMA; there hasn't been one in the past when people like Magnus Damm 
proposed it about four years ago.  Agreed that it's probably going to be 
simpler after your unification patchset is merged, but it seems like we're 
in the unique position where we're extending a feature for an architecture 
because it's simple and makes things cleaner in the code rather than being 
actually useful.
