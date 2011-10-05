Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935154Ab1JETYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:24:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23424 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab1JETY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:24:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=OeEbKj3TyY4B4a5yWiRAa2rL3aOkamsngDpnyfntS9EQar/YBh3CvCsL/0YUJ60Y7
	GUdB+yghVjGsXxAW4K+RA==
Date: Wed, 5 Oct 2011 12:24:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        hpa@zytor.com
Subject: Re: [RFCv3][PATCH 4/4] show page size in /proc/$pid/numa_maps
In-Reply-To: <1317832083.2473.58.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1110051219370.23587@chino.kir.corp.google.com>
References: <20111001000856.DD623081@kernel> <20111001000900.BD9248B8@kernel> <alpine.DEB.2.00.1110042344250.16359@chino.kir.corp.google.com> <1317798564.3099.12.camel@edumazet-laptop> <1317828155.7842.73.camel@nimitz>
 <1317832083.2473.58.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Eric Dumazet wrote:

> > How does it break old scripts?
> > 
> 
> Old scripts just parse numa_maps, and on typical machines where
> hugepages are not used, they dont have to care about page size.
> They assume pages are 4KB.
> 
> Adding a new word (pagesize=...) might break them, but personally I dont
> care.
> 

If your script is only parsing numa_maps, then Dave's effort is actually 
allowing them to be fixed rather than breaking them.  We could silently 
continue to export the page counts without specifying the size (hugetlb 
pages are counted in their true hugepage size, THP pages are counted in 
PAGE_SIZE units), but then a script would always be broken unless they use 
smaps as well.  Dave's addition of pagesize allows numa_maps to stand on 
its own and actually be useful when hugepages are used.
