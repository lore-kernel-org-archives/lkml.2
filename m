Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab1ELT0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:26:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33663 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1ELT0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=B8OZq8tpHZoAzDWDNOTfPZ92OWwejaJn0hfZtqFcDFwY/zJFm1px9daG+Kd7PbtbDs
         H2XKtGtiyf9WVeXegOog==
Date: Thu, 12 May 2011 12:26:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: Remove dependency on CONFIG_FLATMEM from
 online_page()
In-Reply-To: <20110512102515.GA27851@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1105121223500.2407@chino.kir.corp.google.com>
References: <20110502211915.GB4623@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1105111547160.24003@chino.kir.corp.google.com> <20110512102515.GA27851@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, Daniel Kiper wrote:

> > > Memory hotplug code strictly depends on CONFIG_SPARSEMEM.
> > > It means that code depending on CONFIG_FLATMEM in online_page()
> > > is never compiled. Remove it because it is not needed anymore.
> > >
> > > Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> >
> > The code you're patching depends on CONFIG_MEMORY_HOTPLUG_SPARSE, so this
> > is valid.  The changelog should be updated to reflect that, however.
> >
> > Acked-by: David Rientjes <rientjes@google.com>
> 
> No problem, however, this bundle of patches was added to the -mm tree.
> In this situation should I repost whole bundle with relevant changes
> or post only those two patches requested by you ??? For which tree
> should I prepare new version of patches ???
> 

No, I would just reply to the email notification you received when the 
patch went into -mm saying that the changelog should be adjusted to read 
something like

	online_pages() is only compiled for CONFIG_MEMORY_HOTPLUG_SPARSE,
	so there is no need to support CONFIG_FLATMEM code within it.

	This patch removes code that is never used.
