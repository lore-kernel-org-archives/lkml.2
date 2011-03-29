Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1C2VN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:13:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45226 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1C2VNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=WTsuxaWk3tXiCxjgPiuKePx0oh/ji5qAoftYrIfC4CVzikB7sA5cHfGRgJ11wJYqpt
         ebnAZculQT8b1NBtktiQ==
Date: Tue, 29 Mar 2011 14:11:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN()
 macro
In-Reply-To: <20110329173221.GB30387@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1103291408150.1844@chino.kir.corp.google.com>
References: <20110328092412.GC13826@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1103281545220.7148@chino.kir.corp.google.com> <20110329173221.GB30387@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011, Daniel Kiper wrote:

> > These are only valid for CONFIG_SPARSEMEM, so they need to be defined 
> > conditionally.
> 
> OK, however, I think that pfn_to_section_nr()/section_nr_to_pfn()
> should be defined conditionally, too.
> 

Yes, and you could try removing this from include/linux/mm.h:

#ifndef PFN_SECTION_SHIFT
#define PFN_SECTION_SHIFT 0 
#endif

then we'll reveal anything using these conversion macros that don't rely 
on sparsemem.
