Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665Ab1CDOdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:33:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53756 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1CDOdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:33:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=edUeAuhs9QnS17fKzOz4ViiZZWPgHYAQAH5dKiQYPeWc5bqypq5JP3zH7zd7jh88jz
         yUFF5szm4sm2DCTrSJF3AKRzhyN0j4xFTYXcXfCG7/Drdv9+U58NdahipwdtTIgwHCCu
         iM6Z9qGuiivur3pAIfVB2TagVzv25qR5ZKPJQ=
Date: Fri, 4 Mar 2011 15:32:56 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110304143256.GR20499@htj.dyndns.org>
References: <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org>
 <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
 <20110302154215.GN3319@htj.dyndns.org>
 <4D6EB2C3.7040704@kernel.org>
 <4D6EB856.1010004@kernel.org>
 <alpine.DEB.2.00.1103031205070.9993@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103031205070.9993@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 03, 2011 at 12:07:10PM -0800, David Rientjes wrote:
> The new emulation code needs to remove the assumption that node 0 always 
> is online and become more robust since there's no such restriction in the 
> ACPI spec.

Yeah, indeed, that's possible.  ACPI spec isn't really the deciding
factor here.  The node IDs are purely software and a system is
required to have at least one node, so it seems reasonable to require
node 0 to be always online - or even to require all online node IDs to
be consecutive starting from 0.  The only reason we may have holes in
node IDs now is because PXM -> nid mapping isn't released for empty
memory-only nodes.

The biggest downside of deferring checks for this type of rare
conditions to upper layers when not strictly necessary is that it
tends to lead to one-off bugs which trigger very infrequently.

That said, maybe we're already too deep toward that direction and it's
much easier to weed out the assumptions that node0 is always online.

Thanks.

-- 
tejun
