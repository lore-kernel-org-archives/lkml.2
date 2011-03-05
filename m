Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1CEHui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 02:50:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56373 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1CEHuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 02:50:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UrwAym3KxHkLjz1mCxKXf3Y/EpzrkAYHk61VCSzzig/U86wgdgdcWE4so5gVzBwDSx
         t+eiBkKFj+URdrbpqm1jXf1weLojDWl4tQJy5m14R2DvonvWpRoaoSPGEI1EBIAm13RD
         o6zeZBsjTxIQQBzISLmxpm+JUMGVRnaoqJbVo=
Date: Sat, 5 Mar 2011 08:50:33 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86-64, NUMA: Don't assume phys node 0 is
 always online in numa_emulation() handling
Message-ID: <20110305075033.GB20499@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org>
 <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
 <20110304153106.GT20499@htj.dyndns.org>
 <alpine.DEB.2.00.1103041332001.3762@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103041332001.3762@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 01:33:29PM -0800, David Rientjes wrote:
> On Fri, 4 Mar 2011, Tejun Heo wrote:
> 
> > Undetermined entries in emu_nid_to_phys[] are filled with zero
> > assuming that physical node 0 is always online; however, this might
> > not be true depending on hardware configuration.  Find a physical node
> > which is actually online and use it instead.
> > 
> 
> I still don't understand why emu_nid_to_phys[] can't return NUMA_NO_NODE 
> and this needs to be done at all.  An emulated node should be mapped to a 
> physical node based on the address ranges of that emulated node, so it's 
> impossible for that to not map directly to a physical online node.  We 
> don't support memoryless emulated nodes for hotpluggable SRAT entries.

Me neither.  That was the original logic.  I just transformed the
logic into emu_nid_to_phys[].  If you think you can remove that
safely, please go ahead and submit a patch.  That said, it's not
exactly high priority thing to do.

Thanks.

-- 
tejun
