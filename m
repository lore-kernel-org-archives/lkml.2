Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1DUVeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:34:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:20932 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1DUVeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=PfmRDin8HgFcB1sg0sFTEz7PlsExQChqzBgbls6C45r8b7YtWnwv0m/j+O9sCc80j0
         CY/28YoPlOR+mPiF4XoA==
Date: Thu, 21 Apr 2011 14:34:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303421088.4025.52.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104211431500.20201@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211500170.5741@router.home>
 <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com> <1303421088.4025.52.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, James Bottomley wrote:

> >  - parisc: James has already queued "parisc: set memory ranges in 
> >    N_NORMAL_MEMORY when onlined" for 2.6.39, so all he needs now is 
> >    to merge a hybrid of the Kconfig changes requiring CONFIG_NUMA for 
> >    CONFIG_DISCONTIGMEM from KOSAKI-san and myself which also fix the 
> >    compile issues,
> 
> Not quite: if we go this route, we need to sort out our CPU scheduling
> problem as well ... as I said, I don't think we've got all the necessary
> numa machinery in place yet.
> 

Ok, it seems like there're two options for this release cycle:

 (1) merge the patch that enables CONFIG_NUMA for DISCONTIGMEM but only 
     do so if CONFIG_SLUB is enabled to avoid the build error, or

 (2) disallow CONFIG_SLUB for parisc with DISCONTIGMEM.
